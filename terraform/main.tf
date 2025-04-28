# VPC module
module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "rds" {
  source             = "./modules/rds"
  name_prefix        = var.name_prefix
  env                = var.env
  engine             = var.engine
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  username           = var.username
  password           = var.password
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.rds_security_group_id]
}
