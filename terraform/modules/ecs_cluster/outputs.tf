output "cluster_id" {
  description = "The ECS Cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "cluster_name" {
  description = "The ECS Cluster Name"
  value       = aws_ecs_cluster.this.name
}