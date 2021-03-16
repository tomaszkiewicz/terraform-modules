resource "aws_apigatewayv2_route" "public" {
  api_id               = var.api_id
  route_key            = "${var.method} ${var.path}"
  target               = "integrations/${var.integration_id}"
}
