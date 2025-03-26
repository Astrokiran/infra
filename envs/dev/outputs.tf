output "subnet_ids" {
  description = "Dev public subnet IDs"
  value       = module.vpc.public_subnets
} 