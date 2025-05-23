project_name       = "astrokiran-prod"
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]

# Node.js service variables
nodejs_container_image = "node:16-alpine"  # Replace with your actual Node.js image
nodejs_domain_name     = "api.astrokiran.com" # Production domain
nodejs_certificate_arn = "arn:aws:acm:ap-south-1:135808951138:certificate/976ec700-538b-49ac-8740-7dfc740a6a95" # Actual certificate ARN
nodejs_desired_count   = 2