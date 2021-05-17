resource "aws_ses_domain_identity" "domain" {
  for_each = var.domains

  domain = each.key
}

resource "aws_ses_identity_notification_topic" "bounce" {
  for_each = var.domains

  topic_arn                = aws_sns_topic.bounce_notification.arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.domain[each.key].domain
  include_original_headers = true
}

resource "aws_ses_identity_notification_topic" "complaint" {
  for_each = var.domains

  topic_arn                = aws_sns_topic.bounce_notification.arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.domain[each.key].domain
  include_original_headers = true
}

resource "aws_route53_record" "amazonses_verification_record" {
  for_each = var.domains

  zone_id = each.value
  name    = "_amazonses.${each.key}"
  type    = "TXT"
  ttl     = "600"
  records = [
    aws_ses_domain_identity.domain[each.key].verification_token
  ]
}

module dmarc {
  source      = "../ses-dmarc"
  for_each    = var.configure_dmarc ? var.domains : {}
  dns_zone_id = each.value
  domain      = each.key
}

