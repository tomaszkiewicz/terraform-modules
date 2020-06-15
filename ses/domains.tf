data "aws_route53_zone" "dns" {
  for_each = toset(var.domains)

  name = each.value
}

resource "aws_ses_domain_identity" "domain" {
  for_each = toset(var.domains)

  domain = each.value
}

resource "aws_ses_identity_notification_topic" "bounce" {
  for_each = toset(var.domains)

  topic_arn                = aws_sns_topic.bounce_notification.arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.domain[each.value].domain
  include_original_headers = true
}

resource "aws_ses_identity_notification_topic" "complaint" {
  for_each = toset(var.domains)

  topic_arn                = aws_sns_topic.bounce_notification.arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.domain[each.value].domain
  include_original_headers = true
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
