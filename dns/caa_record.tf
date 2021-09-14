resource "aws_route53_record" "main-caa" {
  count   = length(var.caa_records) > 0 ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = var.dns_zone
  type    = "CAA"
  ttl     = 300
  records = var.caa_records
}
