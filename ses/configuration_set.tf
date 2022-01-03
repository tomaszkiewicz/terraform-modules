resource "aws_ses_configuration_set" "configuration_set" {
  name   = var.product_prefix != "" ? "${var.product_prefix}-complaint-set" : "complaint-set"
  reputation_metrics_enabled = true
}

resource "aws_ses_event_destination" "cloudwatch" {
  name                   = var.product_prefix != "" ? "${var.product_prefix}-event-complaint-destination-cloudwatch" : "event-complaint-destination-cloudwatch"
  configuration_set_name = aws_ses_configuration_set.configuration_set.name
  enabled                = true
  matching_types         = ["complaint", "bounce", "renderingFailure"]

  cloudwatch_destination {
    default_value  = "reputation"
    dimension_name = "Email"
    value_source   = "messageTag"
  }
}

resource "aws_ses_event_destination" "sns" {
  name                   = var.product_prefix != "" ? "${var.product_prefix}-event-complaint-destination-sns" : "event-complaint-destination-sns"
  configuration_set_name = aws_ses_configuration_set.configuration_set.name
  enabled                = true
  matching_types         = ["complaint", "bounce", "renderingFailure"]

  sns_destination {
    topic_arn = aws_sns_topic.bounce_notification.arn
  }
}