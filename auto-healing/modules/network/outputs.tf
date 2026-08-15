output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "public subnets id"
  value       = aws_subnet.public[*].id
}