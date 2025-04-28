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
