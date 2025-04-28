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

# RDS module
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

# ALB module
module "alb" {
  source = "./modules/alb"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnet_ids
}

# ECS Service Module
module "ecs_service" {
  source = "./modules/ecs_service"

  cluster_name     = var.cluster_name
  service_name     = var.service_name
  container_name   = var.container_name
  container_image  = var.container_image
  cpu              = 256
  memory           = 512
  desired_count    = 1
  subnets          = module.vpc.private_subnet_ids
  security_groups  = [module.vpc.ecs_security_group_id]
  target_group_arn = module.alb.target_group_arn
}