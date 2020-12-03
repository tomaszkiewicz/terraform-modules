resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "lambda-${var.name}-errors"
  alarm_description         = "This alarm monitors ${var.name} lambda errors"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "1440"
  statistic                 = "Sum"
  threshold                 = 0
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    FunctionName = var.name
  }
}
