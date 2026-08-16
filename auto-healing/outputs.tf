output "load_balancer_url" {
  description = "Public URL of the NGINX web tier"
  value       = "https://${module.load_balancer.dns_name}"
}

output "autoscaling_group_name" {
  description = "Name of the web Auto Scaling Group"
  value       = module.compute.auto_scaling_group_name
}

output "vpc_id" {
  description = "ID of the application VPC"
  value       = module.network.vpc_id
}