# ALB Security Group

resource "aws_security_group" "alb" {
  name_prefix = "${var.name}-alb-"
  description = "Allow HTTP traffic to load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-alb-sg"
  }
}


# Application Load Balancer

resource "aws_lb" "main" {
  name = substr("${var.name}-alb", 0, 32)

  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = "${var.name}-alb"
  }
}


# Target Group

resource "aws_lb_target_group" "web" {
  name = substr("${var.name}-tg", 0, 32)

  port     = var.listener_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true

    path     = var.health_check_path
    protocol = "HTTP"

    healthy_threshold   = 2
    unhealthy_threshold = 2

    interval = 30
    timeout  = 5

    matcher = "200"
  }

  tags = {
    Name = "${var.name}-tg"
  }
}


# HTTP Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn

  port     = var.listener_port
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}