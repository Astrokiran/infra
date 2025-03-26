variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "project_name" {
  type        = string
  description = "Project name to be used in tags"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository"
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Whether to scan images on push"
  default     = true
}

variable "enable_lifecycle_policy" {
  type        = bool
  description = "Whether to enable lifecycle policy"
  default     = false
}

variable "max_image_count" {
  type        = number
  description = "Maximum number of images to keep"
  default     = 30
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the ECR repository"
  default     = {}
} 