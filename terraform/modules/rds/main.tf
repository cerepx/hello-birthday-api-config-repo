resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.name_prefix}-subnet-group"
    Environment = var.env
  }
}

resource "aws_kms_key" "performance_insights" {
  description             = "KMS key for encrypting RDS Performance Insights"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.name_prefix}-rds-pi-key"
    Environment = var.env
  }
}

resource "aws_db_instance" "this" {
  identifier                          = "${var.name_prefix}-db"
  engine                              = var.engine
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  username                            = var.username
  password                            = var.password
  db_subnet_group_name                = aws_db_subnet_group.this.name
  vpc_security_group_ids              = var.security_group_ids
  storage_encrypted                   = true
  skip_final_snapshot                 = true
  deletion_protection                 = true
  iam_database_authentication_enabled = true
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = aws_kms_key.performance_insights.arn

  backup_retention_period = 7

  tags = {
    Name        = "${var.name_prefix}-db"
    Environment = var.env
  }
}
