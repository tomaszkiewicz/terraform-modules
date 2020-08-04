module "lambda" {
  source = "../lambda"

  name    = "slack-alarm-notification"
  runtime = "go1.x"
  handler = "main"
  timeout = 10

  environment = {
    SLACK_WEBHOOK = var.webhook_url
  }

  invoke_allow_principals = [
    "sns.amazonaws.com",
  ]
}
