variable "name" {
  description = "Name prefix for load balancer resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC load balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets load balancer"
  type        = list(string)
}

variable "listener_port" {
  description = "HTTP listener Port"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}