data "aws_route53_zone" "dns" {
  for_each = toset(var.domains)

  name = each.value
}

resource "aws_ses_domain_identity" "domain" {
  for_each = toset(var.domains)

  domain = each.value
}

resource "aws_route53_record" "amazonses_verification_record" {
  for_each = toset(var.domains)

  zone_id = data.aws_route53_zone.dns[each.value].zone_id
  name    = "_amazonses.${each.value}"
  type    = "TXT"
  ttl     = "600"
  records = [
    aws_ses_domain_identity.domain[each.value].verification_token
  ]
}
