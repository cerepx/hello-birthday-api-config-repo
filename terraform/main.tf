module "vpc" {
  source = "./modules/vpc"

  name                = "hello-birthday-vpc"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.101.0/24", "10.10.102.0/24"]
  availability_zones   = ["eu-west-1a", "eu-west-1b"]
}
