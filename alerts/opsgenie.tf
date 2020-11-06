variable "opsgenie_api_key" { default = "" }

module "opsgenie" {
  source = "./opsgenie"
  count  = var.opsgenie_api_key == "" ? 0 : 1

  api_key       = var.opsgenie_api_key
  sns_topic_arn = aws_sns_topic.alerts.arn
}
