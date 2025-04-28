output "api_endpoint" {
  description = "Endpoint URL of the deployed API Gateway"
  value       = aws_apigatewayv2_api.api.api_endpoint
}
