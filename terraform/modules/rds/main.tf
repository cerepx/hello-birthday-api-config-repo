resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.name_prefix}-subnet-group"
    Environment = var.env
  }
}

resource "aws_kms_key" "rds_performance_insights" {
  description         = "KMS key for RDS Performance Insights in RDS module"
  enable_key_rotation = true
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
  iam_database_authentication_enabled = true
  deletion_protection                 = true
  performance_insights_enabled        = var.env == "prod" ? true : false
  performance_insights_kms_key_id     = var.env == "prod" ? aws_kms_key.rds_performance_insights.arn : null

  backup_retention_period = 7

  tags = {
    Name        = "${var.name_prefix}-db"
    Environment = var.env
  }
}
