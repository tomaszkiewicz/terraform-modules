data "external" "download" {
  program = [
    "/bin/sh",
    "-c",
    "if [[ ! -f /tmp/terraform-artifacts/lambda-slack-alarm-notification.zip ]]; then wget -O /tmp/terraform-artifacts/lambda-slack-alarm-notification.zip https://github.com/pragmaticcoders/slack-notification-lambda/releases/download/initial/lambda.zip > /dev/null; fi; echo '{}'",
  ]
}