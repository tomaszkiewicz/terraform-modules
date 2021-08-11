variable "monthly_budget" {
  type = number
}
variable "alert_mails" {
  type    = list
  default = []
}
variable "notifications_sns_topic_arn" { default = "" }
variable "actual_threshold_percent" { default = 100 }
variable "forecast_threshold_percent" { default = 110 }
variable "name" { default = "monthly-budget" }

resource "aws_budgets_budget" "monthly" {
  name         = var.name
  budget_type  = "COST"
  limit_amount = var.monthly_budget + 0.01 // required as tf detects change when integer number used
  limit_unit   = "USD"

  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2017-07-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.actual_threshold_percent
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.alert_mails
    subscriber_sns_topic_arns = [
      var.notifications_sns_topic_arn,
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.forecast_threshold_percent
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.alert_mails
    subscriber_sns_topic_arns = [
      var.notifications_sns_topic_arn,
    ]
  }

}
