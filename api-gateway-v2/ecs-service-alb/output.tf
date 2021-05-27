output "id" {
  value = aws_apigatewayv2_api.main.id
}

output "api_id" {
  value = aws_apigatewayv2_api.main.id
}

output "default_integration_id" {
  value = aws_apigatewayv2_integration.default.id
}

output "vpc_link_id" {
  value = aws_apigatewayv2_vpc_link.service.id
}
