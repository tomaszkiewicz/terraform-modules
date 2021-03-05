resource "aws_apigatewayv2_route" "auth_on" {
  for_each             = toset(var.method)
  api_id               = var.api_id
  route_key            = "${each.key} ${var.path}"
  target               = "integrations/${var.integration_id}"
  authorization_scopes = var.authorization_scopes
  authorizer_id        = var.authorizer_id
  authorization_type   = "JWT"
}

resource "aws_apigatewayv2_route" "auth_off" {
  api_id               = var.api_id
  route_key            = "OPTIONS ${var.path}"
  target               = "integrations/${var.integration_id}"
}
