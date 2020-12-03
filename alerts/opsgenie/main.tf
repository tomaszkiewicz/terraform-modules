resource "aws_sns_topic_subscription" "opsgenie_alarm_notification_subscription" {
  count = var.api_key != "" ? 1 : 0

  topic_arn              = var.sns_topic_arn
  protocol               = "https"
  endpoint_auto_confirms = true
  endpoint               = "https://api.%{if var.eu_region}eu.%{endif}opsgenie.com/v1/json/cloudwatch?apiKey=${var.api_key}"
}
