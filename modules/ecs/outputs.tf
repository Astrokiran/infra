output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "go_app_service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.go_app_service.name
}