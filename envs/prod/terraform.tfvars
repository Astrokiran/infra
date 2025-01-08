project_name       = "astrokiran-prod"
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
go_container_image = "public.ecr.aws/bitnami/go:latest"
desired_count      = 1