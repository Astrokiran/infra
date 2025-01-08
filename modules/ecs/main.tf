###########################
# ECS Cluster
###########################
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}

###########################
# IAM Role for ECS Tasks
###########################
data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json

  tags = {
    Name = "${var.project_name}-ecsTaskExecutionRole"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###########################
# ECS Task Definition
###########################
resource "aws_ecs_task_definition" "go_app_task" {
  family                   = "${var.project_name}-go-task"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name         = "go-app"
      image        = var.go_container_image
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    Name = "${var.project_name}-go-task-def"
  }
}

###########################
# ECS Service
###########################
resource "aws_ecs_service" "go_app_service" {
  name            = "${var.project_name}-go-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.go_app_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  tags = {
    Name = "${var.project_name}-go-service"
  }
}