variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to launch the instance in"
}

variable "your_ip" {
  type        = string
  description = "Your IP address for security group access"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the key pair for SSH access"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
} 