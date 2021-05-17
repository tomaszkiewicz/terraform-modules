resource "aws_apigatewayv2_api" "main" {
  name                       = var.name
  protocol_type              = "WEBSOCKET"
  route_selection_expression = var.route_selection_expression
}

resource "aws_apigatewayv2_integration" "default" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "MOCK"
}

resource "aws_apigatewayv2_route" "default" {
  api_id         = aws_apigatewayv2_api.main.id
  route_key      = "$default"
  operation_name = "DefaultRoute"
  target         = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_apigatewayv2_integration" "connect" {
  api_id                    = aws_apigatewayv2_api.main.id
  integration_type          = "AWS_PROXY"
  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  integration_method        = "POST"
  integration_uri           = var.connect_lambda_invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "connect" {
  api_id         = aws_apigatewayv2_api.main.id
  route_key      = "$connect"
  operation_name = "ConnectRoute"
  target         = "integrations/${aws_apigatewayv2_integration.connect.id}"
  throttling_burst_limit   = var.throttling_burst_limit
  throttling_rate_limit    = var.throttling_rate_limit
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id                    = aws_apigatewayv2_api.main.id
  integration_type          = "AWS_PROXY"
  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  integration_method        = "POST"
  integration_uri           = var.disconnect_lambda_invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id         = aws_apigatewayv2_api.main.id
  route_key      = "$disconnect"
  operation_name = "DisconnectRoute"
  target         = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
  throttling_burst_limit   = var.throttling_burst_limit
  throttling_rate_limit    = var.throttling_rate_limit
}

resource "aws_apigatewayv2_stage" "main" {
  api_id        = aws_apigatewayv2_api.main.id
  deployment_id = aws_apigatewayv2_deployment.main.id
  name          = "live"

  lifecycle {
    ignore_changes = [
      access_log_settings,
    ]
  }
}

resource "aws_apigatewayv2_deployment" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  description = "live"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_apigatewayv2_integration.default),
      jsonencode(aws_apigatewayv2_integration.connect),
      jsonencode(aws_apigatewayv2_integration.disconnect),
      jsonencode(aws_apigatewayv2_route.default),
      jsonencode(aws_apigatewayv2_route.connect),
      jsonencode(aws_apigatewayv2_route.disconnect),
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}
