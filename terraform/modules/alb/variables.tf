variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB is deployed"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to deploy ALB"
}
