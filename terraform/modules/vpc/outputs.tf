output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "rds_security_group_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds.id
}

output "ecs_security_group_id" {
  value       = aws_security_group.ecs.id
  description = "Security Group ID for ECS tasks"
}