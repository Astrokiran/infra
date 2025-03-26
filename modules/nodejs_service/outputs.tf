output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.nodejs_alb.dns_name
}

output "service_url" {
  description = "The URL of the service"
  value       = "https://${var.domain_name}"
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.nodejs_service.name
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.nodejs_tg.arn
}

output "ecs_security_group_id" {
  description = "The ID of the ECS security group"
  value       = aws_security_group.ecs_sg.id
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
} 