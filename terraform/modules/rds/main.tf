resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name_prefix}-subnet-group"
    Environment = var.env
  }
}

resource "aws_db_instance" "this" {
  identifier        = "${var.name_prefix}-db"
  engine            = var.engine
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  username          = var.username
  password          = var.password
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot = true

  tags = {
    Name = "${var.name_prefix}-db"
    Environment = var.env
  }
}
