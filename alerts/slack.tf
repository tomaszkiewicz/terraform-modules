variable "slack_webhook_url" { default = "" }

module "slack" {
  source = "./slack"
  count  = var.slack_webhook_url == "" ? 0 : 1

  webhook_url = var.slack_webhook_url
}
