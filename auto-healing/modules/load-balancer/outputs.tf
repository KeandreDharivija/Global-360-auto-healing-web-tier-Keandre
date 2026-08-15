output "target_group_arn" {
  description = "ARN of the web target group"
  value       = aws_lb_target_group.web.arn
}

output "security_group_id" {
  description = "ID of load balancer security group"
  value       = aws_security_group.alb.id
}

output "dns_name" {
  description = "DNS name of load balancer"
  value       = aws_lb.main.dns_name
}