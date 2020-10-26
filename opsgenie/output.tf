output "sns_topic_arn" {
  value = aws_sns_topic.opsgenie_alarm_notification.arn
}