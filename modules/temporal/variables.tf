variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "ecs_security_group_id" {
  description = "ID of the security group for ECS tasks"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "postgresql_version" {
  description = "Version of PostgreSQL to use"
  type        = string
  default     = "12"
}

variable "temporal_version" {
  description = "Version of Temporal server to use"
  type        = string
  default     = "1.22.3"
}

variable "temporal_ui_version" {
  description = "Version of Temporal UI to use"
  type        = string
  default     = "2.22.3"
}

variable "postgresql_user" {
  description = "PostgreSQL user"
  type        = string
  default     = "temporal"
}

variable "postgresql_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "temporal"
  sensitive   = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
} 