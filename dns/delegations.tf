resource "aws_route53_record" "ns" {
  for_each = var.delegations

  zone_id = aws_route53_zone.main.zone_id
  name    = each.key
  type    = "NS"
  ttl     = 60

  records = each.value
}