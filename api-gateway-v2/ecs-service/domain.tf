module "domain" {
  source = "../domain"

  api_id          = aws_apigatewayv2_api.main.id
  domain_name     = var.domain_name
  dns_zone_id     = var.dns_zone_id
  certificate_arn = var.certificate_arn
  stage           = aws_apigatewayv2_stage.main.name
}
