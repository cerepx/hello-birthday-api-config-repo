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

variable "flow_logs_retention_days" {
  description = "Retention period for VPC Flow Logs in CloudWatch Logs (in days)"
  type        = number
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}


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
