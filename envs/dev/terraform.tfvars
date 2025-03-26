project_name       = "astrokiran-dev"
vpc_cidr           = "10.1.0.0/16"
public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]

# Node.js service variables
nodejs_container_image = "node:16-alpine"  # Replace with your actual Node.js image
nodejs_domain_name     = "dev-api.astrokiran.com" # Development domain
nodejs_certificate_arn = "arn:aws:acm:ap-south-1:135808951138:certificate/976ec700-538b-49ac-8740-7dfc740a6a95" # Actual certificate ARN
nodejs_desired_count   = 1 

# Remove this line
temporal_postgresql_password = "temporal" 

your_ip       = "122.172.84.231"  # Replace with your IP
key_pair_name = "temporal-ec2-key"    # Replace with your key pair name 