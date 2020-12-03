resource "aws_cloudwatch_metric_alarm" "daily_sent_limit" {
  count = var.daily_sent_limit > 0 && var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "ses-daily-sent-limit"
  alarm_description         = "This alert monitors the number of mails sent during last day"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Send"
  namespace                 = "AWS/SES"
  period                    = "1440"
  statistic                 = "Sum"
  threshold                 = var.daily_sent_limit * 0.9
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]
}
