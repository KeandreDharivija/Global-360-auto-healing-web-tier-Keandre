# Amazon Linux AMI

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Web Security Group

resource "aws_security_group" "web" {
  name_prefix = "${var.name}-web-"
  description = "Security group for NGINX web instances"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-web-sg"
  }
}


# Allow HTTP from Application Load Balancer

resource "aws_vpc_security_group_ingress_rule" "web_from_alb" {
  security_group_id = aws_security_group.web.id

  referenced_security_group_id = var.alb_security_group_id

  from_port   = var.web_port
  to_port     = var.web_port
  ip_protocol = "tcp"

  description = "Allow HTTP traffic from the ALB"
}


# Allow instances to access the Internet for package installation

resource "aws_vpc_security_group_egress_rule" "web_outbound" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}


# Launch Template

resource "aws_launch_template" "web" {
  name_prefix = "${var.name}-web-"

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = base64encode(
    file("${path.module}/../../scripts/user-data.sh")
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "${var.name}-web"
      Role      = "web"
      ManagedBy = "Terraform"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Auto Scaling Group

resource "aws_autoscaling_group" "web" {
  name = "${var.name}-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 2

  vpc_zone_identifier = var.public_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "web"
    propagate_at_launch = true
  }
}