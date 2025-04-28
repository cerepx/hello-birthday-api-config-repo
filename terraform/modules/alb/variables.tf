variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB is deployed"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to deploy ALB"
}

variable "security_groups" {
  description = "List of security groups to associate with the ALB"
  type        = list(string)
}
