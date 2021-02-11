resource "aws_cloudwatch_log_metric_filter" "filter" {
  name           = var.name
  pattern        = var.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name      = var.metric_name
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "log-metric-${var.name}"
  alarm_description         = "This alarm monitors log group ${var.log_group_name} for pattern ${var.pattern}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = var.metric_name
  namespace                 = var.metric_namespace
  period                    = "60"
  statistic                 = "Average"
  threshold                 = 1
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]
}
