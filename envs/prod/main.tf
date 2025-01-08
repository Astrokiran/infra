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
# 5. Reference the ECS module
###########################################################
module "ecs" {
  source = "../../modules/ecs"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  go_container_image = var.go_container_image
  desired_count      = var.desired_count
  ecs_security_group_id = module.security_groups.ecs_security_group_id
}


###########################################################
# (Optional) Outputs from modules
###########################################################
output "vpc_id" {
  description = "The VPC ID for staging"
  value       = module.vpc.vpc_id
}

output "ecs_cluster_name" {
  description = "The ECS Cluster Name for staging"
  value       = module.ecs.ecs_cluster_name
}