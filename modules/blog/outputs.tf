output "environment_url" {
  description = "URL of the environment"
  value       = module.alb.dns_name
}
