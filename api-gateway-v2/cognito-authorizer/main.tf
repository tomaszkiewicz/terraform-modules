resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id           = var.api_id
  name             = var.name
  identity_sources = var.identity_sources
  authorizer_type  = "JWT"

  jwt_configuration {
    audience = [
      var.cognito_user_pool_client_id,
    ]
    issuer = "https://${var.cognito_user_pool_endpoint}"
  }
}
