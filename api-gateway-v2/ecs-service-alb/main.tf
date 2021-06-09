resource "aws_apigatewayv2_api" "main" {
  name          = var.name
  protocol_type = "HTTP"

  dynamic "cors_configuration" {
    for_each = var.enable_cors ? ["hack"] : []

    content {
      allow_headers     = var.cors_allow_headers
      allow_methods     = var.cors_allow_methods
      allow_origins     = var.cors_allow_origins
      max_age           = var.cors_max_age
      allow_credentials = var.cors_allow_credentials
      expose_headers    = var.cors_expose_headers
    }
  }
}



resource "aws_apigatewayv2_integration" "default" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.service_arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.service.id
  request_parameters = var.integration_request_parameters

  lifecycle {
    ignore_changes = [
      passthrough_behavior,
    ]
  }
}

resource "aws_apigatewayv2_route" "default" {
  count          = var.create_default_route ? 1 : 0
  api_id         = aws_apigatewayv2_api.main.id
  route_key      = "$default"
  operation_name = "DefaultRoute"
  target         = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "live"
  auto_deploy = true

  lifecycle {
    ignore_changes = [
      access_log_settings,
      deployment_id,
    ]
  }
}

resource "aws_cloudwatch_log_group" "gw_access" {
  count             = var.enable_access_log ? 1 : 0
  name              = "/api-gateway/${var.name}"
  retention_in_days = var.logs_retention_days
}
