###########################################################
# 1. Reference the VPC module
###########################################################
module "vpc" {
  source = "../../modules/vpc"

  project_name   = var.project_name
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
}

###########################################################
# 2. AWS Organizations Module
###########################################################
module "aws_organizations" {
  source = "../../modules/aws_organizations"
}

###########################################################
# 3. IAM Groups Module
###########################################################
module "iam_groups" {
  source       = "../../modules/iam_groups"
  project_name = var.project_name
}

###########################################################
# 4. Security Group Module
###########################################################
module "security_groups" {
  source       = "../../modules/security_groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

###########################################################
# 5. ECS Cluster
###########################################################
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}

###########################################################
# 5. ECR Repository for NimbusGate
###########################################################
module "nimbus_gate_ecr" {
  source = "../../modules/ecr"

  repository_name = "nimbus_gate"
  project_name    = var.project_name
  environment     = "prod"
  
  # For production, we may want immutable tags
  image_tag_mutability = "IMMUTABLE"
  
  # Optional lifecycle policy
  enable_lifecycle_policy = true
  max_image_count         = 20
  
  additional_tags = {
    Service = "NimbusGate"
  }
}

###########################################################
# 6. Node.js Service Module
###########################################################
module "nodejs_service" {
  source = "../../modules/nodejs_service"

  project_name         = "${var.project_name}-nimbusgate"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnets
  nodejs_container_image = "135808951138.dkr.ecr.ap-south-1.amazonaws.com/nimbus_gate:latest"
  container_port       = 3000
  health_check_path    = "/health"
  domain_name          = var.nodejs_domain_name
  certificate_arn      = var.nodejs_certificate_arn
  desired_count        = var.nodejs_desired_count
  ecs_cluster_id       = aws_ecs_cluster.this.id

  # Environment variables for your Node.js application if needed
  environment_variables = [
    {
      name  = "NODE_ENV"
      value = "production"
    }
  ]
}

###########################################################
# Outputs from modules
###########################################################
output "vpc_id" {
  description = "The VPC ID for prod"
  value       = module.vpc.vpc_id
}

output "ecs_cluster_name" {
  description = "The ECS Cluster Name for prod"
  value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_id" {
  description = "The ECS Cluster ID for prod"
  value       = aws_ecs_cluster.this.id
}

output "nodejs_service_url" {
  description = "The URL of the Node.js service"
  value       = module.nodejs_service.service_url
}

output "nodejs_alb_dns_name" {
  description = "The DNS name of the Node.js ALB"
  value       = module.nodejs_service.alb_dns_name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository for NimbusGate"
  value       = module.nimbus_gate_ecr.repository_url
}