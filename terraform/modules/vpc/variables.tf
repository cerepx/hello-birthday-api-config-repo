variable "name" {
  description = "Base name for resources"
  type        = string
}

variable "env" {
  description = "Environment: dev or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "flow_logs_retention_days" {
  description = "Retention period for VPC Flow Logs in CloudWatch Logs (in days)"
  type        = number
  default     = 30
}

variable "aws_region" {
  description = "AWS region for VPC endpoints (example: eu-west-1)"
  type        = string
}
