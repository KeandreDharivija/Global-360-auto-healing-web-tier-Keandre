output "auto_scaling_group_name" {
  description = "Auto scaling group name"
  value       = aws_autoscaling_group.web.name
}