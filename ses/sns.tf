resource "aws_sns_topic" "bounce_notification" {
  name = "bounce-notification"
}

resource "aws_sns_topic_subscription" "bounce_notification_topic_subscription" {
  topic_arn = aws_sns_topic.bounce_notification.arn
  protocol = "lambda"
  endpoint = var.bounce_notification_lambda_arn
}

resource "aws_lambda_permission" "bounce_notification_sns" {
  statement_id = "AllowExecutionFromSES"
  action = "lambda:InvokeFunction"
  function_name = var.bounce_notification_lambda_name
  principal = "sns.amazonaws.com"
  source_arn = aws_sns_topic.bounce_notification.arn
}
