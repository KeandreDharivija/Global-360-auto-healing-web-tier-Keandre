variable "name" {
  description = "Name for compute resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for compute resources"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet IDs used by Auto Scaling Group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the load balancer target group"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the load balancer security group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the web tier"
  type        = string
  default     = "t4g.nano"
}

variable "web_port" {
  description = "NGINX port"
  type        = number
  default     = 80
}