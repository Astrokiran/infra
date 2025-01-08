output "subnet_ids" {
  description = "Staging public subnet IDs"
  value       = module.vpc.public_subnets
}