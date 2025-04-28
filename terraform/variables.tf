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

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

# RDS config variables
variable "engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
}

variable "allocated_storage" {
  description = "RDS allocated storage size"
  type        = number
}

variable "username" {
  description = "Master username for RDS"
  type        = string
}

variable "password" {
  description = "Master password for RDS"
  type        = string
}

# ECS config variables
variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS Service name"
  type        = string
}

variable "container_name" {
  description = "ECS Container name inside the Task Definition"
  type        = string
}

variable "container_image" {
  description = "Container image URI for the ECS service"
  type        = string
}

variable "gunicorn_workers" {
  description = "Define GUNICORN_WORKERS environment variable"
  type        = string
}
