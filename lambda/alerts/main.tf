resource "aws_cloudwatch_metric_alarm" "lambda_concurrent_executions" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "lambda-concurrent-executions"
  alarm_description         = "This alarm monitors concurrent executions sum across all lambdas"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "ConcurrentExecutions"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = var.concurrent_executions_threshold
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda_invocations" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "lambda-invocations"
  alarm_description         = "This alarm monitors invocations sum across all lambdas"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Invocations"
  namespace                 = "AWS/Lambda"
  period                    = "3600"
  statistic                 = "Sum"
  threshold                 = var.invocations_threshold
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "lambda-throttles"
  alarm_description         = "This alarm monitors throttles sum across all lambdas"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Throttles"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 0
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]
}
