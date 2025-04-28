output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_instance_id" {
  value = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "The database endpoint to connect"
  value       = aws_db_instance.this.endpoint
}