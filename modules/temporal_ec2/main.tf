# Security Group for Temporal EC2
resource "aws_security_group" "temporal" {
  name        = "${var.project_name}-temporal-sg"
  description = "Security group for Temporal server"
  vpc_id      = var.vpc_id

  # SSH access from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.your_ip}/32"]
  }

  # Temporal UI access from your IP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.your_ip}/32"]
  }

  # Temporal server port (internal access only)
  ingress {
    from_port   = 7233
    to_port     = 7233
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-temporal-sg"
  }
}

# EC2 Instance Role
resource "aws_iam_role" "temporal_ec2_role" {
  name = "${var.project_name}-temporal-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "temporal" {
  name = "${var.project_name}-temporal-instance-profile"
  role = aws_iam_role.temporal_ec2_role.name
}

# EC2 Instance
resource "aws_instance" "temporal" {
  ami                    = var.ami_id
  instance_type         = "t2.micro"
  subnet_id             = var.subnet_id
  iam_instance_profile  = aws_iam_instance_profile.temporal.name
  vpc_security_group_ids = [aws_security_group.temporal.id]
  key_name             = "ask-website-ec2-secret"

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Install Docker
              snap install docker
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Create Temporal directory
              mkdir -p /opt/temporal
              chown -R ec2-user:ec2-user /opt/temporal
              EOF

  tags = {
    Name = "${var.project_name}-temporal"
  }
} 