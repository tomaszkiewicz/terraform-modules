resource "aws_cloudwatch_metric_alarm" "api-4xx" {
  alarm_name                = "api-gateway-4xx-response"
  alarm_description         = "This alarm monitors api 4xx response"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "4XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 10
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  dimensions = {
    ApiName = var.api_name
  }
}

resource "aws_cloudwatch_metric_alarm" "api-5xx" {
  alarm_name                = "api-gateway-5xx-response"
  alarm_description         = "This alarm monitors api 5xx response"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "5XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 10
  treat_missing_data        = "ignore"
  alarm_actions             = [var.notifications_sns_topic_arn]
  ok_actions                = [var.notifications_sns_topic_arn]
  dimensions = {
    ApiName = var.api_name
  }
}

variable "notifications_sns_topic_arn" {
  default = ""
}
variable "api_name" {
  default = ""
}
