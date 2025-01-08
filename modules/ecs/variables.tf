variable "project_name" {
  type        = string
  description = "Project name or identifier"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where ECS will run"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ECS tasks"
}

variable "go_container_image" {
  type        = string
  description = "Docker image URI for the Go web server"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks to run"
  default     = 1
}

variable "ecs_security_group_id" {
  description = "Security group ID to associate with the instance"
  type        = string
}