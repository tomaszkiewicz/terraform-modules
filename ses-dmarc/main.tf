resource "aws_route53_record" "dmarc" {
  zone_id = var.dns_zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [
    "v=DMARC1; p=reject; pct=100"]
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = var.domain
}

resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = var.dns_zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
