resource "aws_cloudwatch_metric_alarm" "swap_usage" {
  count = var.notifications_sns_topic_arn != "" ? var.cluster_size : 0

  alarm_name          = "${var.name}-00${count.index + 1}-swap-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "SwapUsage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  treat_missing_data  = "missing"
  alarm_actions = [
    var.notifications_sns_topic_arn,
  ]
  ok_actions = [
    var.notifications_sns_topic_arn,
  ]
  insufficient_data_actions = [
    var.notifications_sns_topic_arn,
  ]

  dimensions = {
    CacheClusterId = "${var.name}-00${count.index + 1}"
  }
}
