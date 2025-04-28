resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.env
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name}-public-subnet-${count.index + 1}"
    Environment = var.env
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.name}-private-subnet-${count.index + 1}"
    Environment = var.env
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-public-rt"
    Environment = var.env
  }
}

# Public Internet Route
resource "aws_route" "default_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate all Public Subnets to Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-private-rt"
    Environment = var.env
  }
}

# Associate all Private Subnets to Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_kms_key" "vpc_flow_logs" {
  description             = "KMS key for VPC Flow Logs encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.name}-flow-logs-kms"
    Environment = var.env
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "/aws/vpc/flow-logs"
}

resource "aws_iam_role" "flow_logs_role" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "vpc-flow-logs.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }]
  })
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.flow_logs_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource" : "*"
    }]
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs/${var.name}"
  retention_in_days = var.flow_logs_retention_days
  kms_key_id        = var.env == "prod" ? aws_kms_key.vpc_flow_logs.arn : null
}

resource "aws_flow_log" "vpc_flow_logs" {
  vpc_id               = aws_vpc.this.id
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
  traffic_type         = "ALL"
}

resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "Allow MySQL access from VPC private subnets only"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "MySQL from private subnets"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    description = "Allow all outbound traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name        = "${var.name}-rds-sg"
    Environment = var.env
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.name}-ecs-sg"
  description = "Allow inbound HTTP from ALB"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP from ALB"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-ecs-sg"
    Environment = var.env
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-alb-sg"
    Environment = var.env
  }
}

# VPC Endpoint Security Group (only for Interface endpoints)
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.name}-vpc-endpoints-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS (443) from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-vpc-endpoints-sg"
    Environment = var.env
  }
}

# Interface Endpoint for ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name = "${var.name}-ecr-api-endpoint"
  }
}

# Interface Endpoint for ECR DKR
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id             = aws_vpc.this.id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name = "${var.name}-ecr-dkr-endpoint"
  }
}

# Gateway Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name = "${var.name}-s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name}-cw-endpoint"
  }
}