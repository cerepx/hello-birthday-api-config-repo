variable "env" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "cluster_name" {
  description = "The ECS cluster name"
  type        = string
}

variable "container_name" {
  description = "Container name for the task definition"
  type        = string
}

variable "container_image" {
  description = "Docker container image URI"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MB for the task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS service tasks"
  type        = number
  default     = 1
}

variable "subnets" {
  description = "Subnets for ECS tasks"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target group to attach ECS service to"
  type        = string
}

variable "aws_region" {
  description = "AWS region for VPC endpoints (example: eu-west-1)"
  type        = string
}

variable "rds_db_endpoint" {
  description = "RDS database endpoint hostname"
  type        = string
}

variable "app_db_user" {
  description = "The database username for the application"
  type        = string
}

variable "app_db_password" {
  description = "The database password for the application"
  type        = string
}

variable "app_db_name" {
  description = "The database password for the application"
  type        = string
}

variable "gunicorn_workers" {
  description = "Define GUNICORN_WORKERS environment variable"
  type        = string
}