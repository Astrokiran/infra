variable "project_name" {
  type        = string
  description = "Project name or identifier"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where resources will be deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB and ECS tasks"
}

variable "nodejs_container_image" {
  type        = string
  description = "Docker image URI for the Node.js application"
}

variable "container_port" {
  type        = number
  description = "Port the container exposes"
  default     = 3000
}

variable "health_check_path" {
  type        = string
  description = "Path for health checks"
  default     = "/health"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks to run"
  default     = 2
}

variable "domain_name" {
  type        = string
  description = "Custom domain name for the ALB"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for HTTPS"
}

variable "environment_variables" {
  type        = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables for the Node.js application"
  default     = []
}

variable "ecs_cluster_id" {
  type        = string
  description = "ID of the existing ECS cluster to use"
} 