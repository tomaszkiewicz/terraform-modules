resource "aws_sns_topic" "opsgenie_alarm_notification" {
  name = "opsgenie-alarm-notification"
}

resource "aws_sns_topic_subscription" "opsgenie_alarm_notification_subscription" {
  topic_arn              = aws_sns_topic.opsgenie_alarm_notification.arn
  protocol               = "https"
  endpoint_auto_confirms = true
  endpoint               = "https://api.opsgenie.com/v1/json/cloudwatch?apiKey=${var.api_key}"
}
