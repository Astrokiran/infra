output "temporal_postgresql_service_name" {
  description = "Name of the Temporal PostgreSQL service"
  value       = aws_ecs_service.temporal_postgresql.name
}

output "temporal_server_service_name" {
  description = "Name of the Temporal server service"
  value       = aws_ecs_service.temporal_server.name
}

output "temporal_ui_service_name" {
  description = "Name of the Temporal UI service"
  value       = aws_ecs_service.temporal_ui.name
}

output "temporal_postgresql_task_definition_arn" {
  description = "ARN of the Temporal PostgreSQL task definition"
  value       = aws_ecs_task_definition.temporal_postgresql.arn
}

output "temporal_server_task_definition_arn" {
  description = "ARN of the Temporal server task definition"
  value       = aws_ecs_task_definition.temporal_server.arn
}

output "temporal_ui_task_definition_arn" {
  description = "ARN of the Temporal UI task definition"
  value       = aws_ecs_task_definition.temporal_ui.arn
} 