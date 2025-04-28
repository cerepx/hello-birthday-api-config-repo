variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "env" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., mysql)"
  type        = string
  default     = "mysql"
}

variable "instance_class" {
  description = "Instance type for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "username" {
  description = "Master username for RDS"
  type        = string
}

variable "password" {
  description = "Master password for RDS"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}
