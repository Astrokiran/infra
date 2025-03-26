variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
  
  validation {
    condition     = length(var.public_subnets) > 1
    error_message = "You must specify at least 2 public subnets for high availability."
  }
}