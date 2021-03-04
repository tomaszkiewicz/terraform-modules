output "rest_api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.api.root_resource_id
}

output "proxy_resource_id" {
  value = aws_api_gateway_resource.lambda.id
}

output "stage_name" {
  value = var.stage_name
}

output "invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}
