resource "aws_cloudwatch_metric_alarm" "burst_credit_balance" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "${var.name} burst credit balance"
  alarm_description         = "Monitors EFS burst credits balance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "BurstCreditBalance"
  namespace                 = "AWS/EFS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = var.cloudwatch_credit_balance_threshold
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    FileSystemId = aws_efs_file_system.main.id
  }
}
