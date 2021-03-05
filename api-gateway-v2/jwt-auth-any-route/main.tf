resource "aws_apigatewayv2_route" "auth" {
  api_id               = var.api_id
  route_key            = "${var.method} ${var.path}"
  target               = "integrations/${var.integration_id}"
  authorization_scopes = var.authorization_scopes
  authorizer_id        = var.authorizer_id
  authorization_type   = "JWT"
}
