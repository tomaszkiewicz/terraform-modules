variable "sns_topic_name" { default = "alerts" }

resource "aws_sns_topic" "alerts" {
  name = var.sns_topic_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
