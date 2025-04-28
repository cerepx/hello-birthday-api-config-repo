resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.container_image
      portMappings = [
        {
          containerPort = 5050
          hostPort      = 5050
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MYSQL_HOST"
          value = split(":", var.rds_db_endpoint)[0]
        },
        {
          name  = "MYSQL_USER"
          value = var.app_db_user
        },
        {
          name  = "MYSQL_PASSWORD"
          value = var.app_db_password
        },
        {
          name  = "MYSQL_DATABASE"
          value = var.app_db_name
        },
        {
          name  = "GUNICORN_WORKERS"
          value = var.gunicorn_workers
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name          = var.service_name
  cluster       = var.cluster_name
  launch_type   = "FARGATE"
  desired_count = var.desired_count

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = 5050
  }

  task_definition = aws_ecs_task_definition.this.arn
}

# ECS Task Execution Role (for pulling images, writing logs)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.service_name}-exec"

  assume_role_policy = data.aws_iam_policy_document.execution_assume_role.json

  tags = {
    Name        = "${var.service_name}-exec"
    Environment = var.env
  }
}

data "aws_iam_policy_document" "execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role (optional, only if container app needs AWS API access)
resource "aws_iam_role" "task_role" {
  name = "${var.service_name}-task"

  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json

  tags = {
    Name        = "${var.service_name}-task"
    Environment = var.env
  }
}

data "aws_iam_policy_document" "task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 7

  tags = {
    Environment = var.env
  }
}
