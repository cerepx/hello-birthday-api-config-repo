variable "api_name" {
  description = "Name for the API Gateway"
  type        = string
}

variable "vpc_link_name" {
  description = "Name for VPC Link to connect API Gateway to ALB"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the existing ALB (HTTP protocol prefixed, e.g., http://my-alb.example.com)"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of subnets where the existing ALB resides"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security group IDs associated with the ALB"
  type        = list(string)
}
