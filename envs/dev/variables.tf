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

variable "nodejs_container_image" {
  type        = string
  description = "Container image for the Node.js application"
}

variable "nodejs_domain_name" {
  type        = string
  description = "Domain name for the Node.js service"
}

variable "nodejs_certificate_arn" {
  type        = string
  description = "ARN of ACM certificate for the Node.js service domain"
}

variable "nodejs_desired_count" {
  type        = number
  description = "Number of ECS tasks for Node.js service"
  default     = 1
} 