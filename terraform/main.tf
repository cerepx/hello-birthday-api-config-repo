# VPC module
module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  env                  = var.env
  aws_region           = var.aws_region
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

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnet_ids
  security_groups = [module.vpc.alb_security_group_id]
}

# ECS Cluster Module
module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  cluster_name = var.cluster_name
}

# ECS Service Module
module "ecs_service" {
  source = "./modules/ecs_service"

  env              = var.env
  aws_region       = var.aws_region
  cluster_name     = var.cluster_name
  service_name     = var.service_name
  container_name   = var.container_name
  container_image  = var.container_image
  app_db_user      = var.username
  app_db_password  = var.password
  app_db_name      = var.database_name
  gunicorn_workers = var.gunicorn_workers
  rds_db_endpoint  = module.rds.db_endpoint
  cpu              = 256
  memory           = 512
  desired_count    = 1
  subnets          = module.vpc.private_subnet_ids
  security_groups  = [module.vpc.ecs_security_group_id]
  target_group_arn = module.alb.target_group_arn
}

module "api_gateway" {
  source = "./modules/api_gateway"

  api_name               = var.api_name
  vpc_link_name          = var.vpc_link_name
  alb_listener_arn       = module.alb.listener_arn
  subnet_ids             = module.vpc.private_subnet_ids
  alb_security_group_ids = [module.vpc.alb_security_group_id]
}
