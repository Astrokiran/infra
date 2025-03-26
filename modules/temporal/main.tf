resource "aws_ecs_task_definition" "temporal_postgresql" {
  family                   = "${var.project_name}-temporal-postgresql"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name         = "temporal-postgresql"
      image        = "postgres:${var.postgresql_version}"
      essential    = true
      environment = [
        {
          name  = "POSTGRES_PASSWORD"
          value = var.postgresql_password
        },
        {
          name  = "POSTGRES_USER"
          value = var.postgresql_user
        }
      ]
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-temporal-postgresql"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-temporal-postgresql-task"
  }
}

resource "aws_ecs_task_definition" "temporal_server" {
  family                   = "${var.project_name}-temporal-server"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name         = "temporal-server"
      image        = "temporalio/auto-setup:${var.temporal_version}"
      essential    = true
      environment = [
        {
          name  = "DB"
          value = "postgres12"
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "POSTGRES_USER"
          value = var.postgresql_user
        },
        {
          name  = "POSTGRES_PWD"
          value = var.postgresql_password
        },
        {
          name  = "POSTGRES_SEEDS"
          value = "temporal-postgresql"
        },
        {
          name  = "DYNAMIC_CONFIG_FILE_PATH"
          value = "config/dynamicconfig/development-sql.yaml"
        }
      ]
      portMappings = [
        {
          containerPort = 7233
          hostPort      = 7233
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-temporal-server"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-temporal-server-task"
  }
}

resource "aws_ecs_task_definition" "temporal_ui" {
  family                   = "${var.project_name}-temporal-ui"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name         = "temporal-ui"
      image        = "temporalio/ui:${var.temporal_ui_version}"
      essential    = true
      environment = [
        {
          name  = "TEMPORAL_ADDRESS"
          value = "temporal-server:7233"
        },
        {
          name  = "TEMPORAL_CORS_ORIGINS"
          value = "*"
        }
      ]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-temporal-ui"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-temporal-ui-task"
  }
}

resource "aws_ecs_service" "temporal_postgresql" {
  name            = "${var.project_name}-temporal-postgresql"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.temporal_postgresql.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  tags = {
    Name = "${var.project_name}-temporal-postgresql-service"
  }
}

resource "aws_ecs_service" "temporal_server" {
  name            = "${var.project_name}-temporal-server"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.temporal_server.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_service.temporal_postgresql]

  tags = {
    Name = "${var.project_name}-temporal-server-service"
  }
}

resource "aws_ecs_service" "temporal_ui" {
  name            = "${var.project_name}-temporal-ui"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.temporal_ui.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_service.temporal_server]

  tags = {
    Name = "${var.project_name}-temporal-ui-service"
  }
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "temporal_postgresql" {
  name              = "/ecs/${var.project_name}-temporal-postgresql"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-temporal-postgresql-logs"
  }
}

resource "aws_cloudwatch_log_group" "temporal_server" {
  name              = "/ecs/${var.project_name}-temporal-server"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-temporal-server-logs"
  }
}

resource "aws_cloudwatch_log_group" "temporal_ui" {
  name              = "/ecs/${var.project_name}-temporal-ui"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-temporal-ui-logs"
  }
} 