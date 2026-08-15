variable "name" {
  description = "Name prefix for network resources"
  type        = string
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
    error_message = "At least two Availability Zones are required"
  }
}
