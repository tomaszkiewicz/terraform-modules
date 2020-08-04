output "slack_notification_sns_topic_arn" {
  value = aws_sns_topic.slack_alarm_notification.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.slack_alarm_notification.arn
}

output "function_name" {
  value = "slack-alarm-notification"
}

output "function_arn" {
  value = module.lambda.arn
}
