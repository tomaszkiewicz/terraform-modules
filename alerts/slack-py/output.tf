output "function_name" {
  value = "slack-alarm-notification"
}

output "function_arn" {
  value = module.lambda.arn
}
