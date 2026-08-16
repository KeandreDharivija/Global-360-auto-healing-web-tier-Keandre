variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "auto-healing-web"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "demo"

  validation {
    condition     = contains(["dev", "test", "demo", "prod"], var.environment)
    error_message = "Environment must be dev, test, demo, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone_count" {
  description = "Number of Availability Zones"
  type        = number
  default     = 2

  validation {
    condition     = var.availability_zone_count >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "instance_type" {
  description = "EC2 instance type used by the web tier"
  type        = string
  default     = "t4g.nano"
}