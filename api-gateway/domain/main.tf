resource "aws_api_gateway_base_path_mapping" "domain" {
  api_id      = var.rest_api_id
  stage_name  = var.stage_name
  domain_name = var.domain_name

  depends_on = [
    aws_api_gateway_domain_name.domain,
  ]
}

resource "aws_api_gateway_domain_name" "domain" {
  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn
}

resource "aws_route53_record" "domain" {
  count = var.create_dns_record ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.domain.cloudfront_zone_id
    evaluate_target_health = true
  }
}
