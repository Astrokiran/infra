variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnets for the VPC"
}

variable "go_container_image" {
  type        = string
  description = "Container image for the Go application"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks"
  default     = 1
}