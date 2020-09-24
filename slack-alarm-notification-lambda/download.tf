data "external" "download" {
  program = [
    "/bin/sh",
    "-c",
    "wget -O /tmp/terraform-artifacts/lambda-slack-alarm-notification.zip https://github.com/tomaszkiewicz/slack-notification-lambda/releases/download/initial/lambda.zip > /dev/null; echo '{}'",
  ]

}