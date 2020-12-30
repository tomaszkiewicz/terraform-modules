resource "aws_apigatewayv2_route" "auth" {
  api_id               = var.api_id
  route_key            = "${var.method} ${var.path}"
  target               = "integrations/${var.integration_id}"
  authorization_scopes = var.authorization_scopes
  authorizer_id        = aws_apigatewayv2_authorizer.api.id
  authorization_type   = "JWT"
}

resource "aws_apigatewayv2_authorizer" "api" {
  api_id           = var.api_id
  authorizer_type  = "JWT"
  identity_sources = var.identity_sources
  name             = "cognito"

  jwt_configuration {
    audience = [
      var.cognito_user_pool_client_id,
    ]
    issuer = "https://${var.cognito_user_pool_endpoint}"
  }
}
