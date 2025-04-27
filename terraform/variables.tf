variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "name" {
  description = "Base name for naming resources"
  type        = string
}

variable "env" {
  description = "Environment (dev or prod)"
  type        = string
}

# VPC and Subnets
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}
