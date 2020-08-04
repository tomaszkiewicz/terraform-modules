resource "aws_sns_topic" "slack_alarm_notification" {
  name = "slack-alarm-notification-topic"
}

resource "aws_sns_topic_subscription" "slack_alarm_notification_topic_subscription" {
  topic_arn = aws_sns_topic.slack_alarm_notification.arn
  protocol  = "lambda"
  endpoint  = module.lambda.arn
}
