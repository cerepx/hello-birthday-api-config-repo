output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "task_role_arn" {
  description = "The ARN of the ECS task role"
  value       = aws_iam_role.task_role.arn
}
