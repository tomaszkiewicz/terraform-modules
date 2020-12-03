resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "rds-${var.name}-free-storage-space"
  alarm_description         = "This alarm monitors rds ${var.name} free storage space"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = var.allocated_storage * 1000000000 * 0.2
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "rds-${var.name}-cpu-credit-balance"
  alarm_description         = "Monitors cpu credit balance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "4"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "100"
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "rds-${var.name}-cpu-utilization"
  alarm_description         = "Monitors cpu utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.name
  }
}

resource "aws_cloudwatch_metric_alarm" "connections_count" {
  count = var.notifications_sns_topic_arn != "" ? 1 : 0

  alarm_name                = "rds-${var.name}-connection-count"
  alarm_description         = "Monitors number of connections to the database"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = var.connections_threshold
  treat_missing_data        = "missing"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  insufficient_data_actions = [var.notifications_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.name
  }
}
