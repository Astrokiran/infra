output "ecs_security_group_id" {
  description = "Security Group ID for ECS Fargate tasks"
  value       = aws_security_group.ecs_service_sg.id
}