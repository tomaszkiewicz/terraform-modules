variable "api_id" {}
variable "domain_name" {}
variable "dns_zone_id" {}
variable "certificate_arn" {}
variable "create_dns_record" { default = true }
variable "stage" { default = "live" }

resource "aws_apigatewayv2_api_mapping" "main" {
  api_id      = var.api_id
  domain_name = aws_apigatewayv2_domain_name.main.domain_name
  stage       = var.stage
}

resource "aws_apigatewayv2_domain_name" "main" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "main" {
  count = var.create_dns_record ? 1 : 0

  name    = var.domain_name
  type    = "A"
  zone_id = var.dns_zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
