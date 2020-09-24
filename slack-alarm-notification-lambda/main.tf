module "lambda" {
  source = "../lambda"

  name        = "slack-alarm-notification"
  source_file = "/tmp/terraform-artifacts/lambda-slack-alarm-notification.zip"
  runtime     = "go1.x"
  handler     = "main"
  timeout     = 10

  environment = {
    SLACK_WEBHOOK = var.webhook_url
  }

  invoke_allow_principals = [
    "sns.amazonaws.com",
  ]
}
