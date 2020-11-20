
resource "aws_cloudwatch_event_rule" "schedule" {
  count = var.schedule_expression != "" ? 1 : 0

  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "schedule" {
  count = var.schedule_expression != "" ? 1 : 0

  rule = aws_cloudwatch_event_rule.schedule[0].name
  arn = join("",
    aws_lambda_function.lambda_external.*.arn,
    aws_lambda_function.lambda_source_dir.*.arn,
    aws_lambda_function.lambda_source_file.*.arn,
  )
}

resource "aws_lambda_permission" "schedule" {
  count = var.schedule_expression != "" ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = var.name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule[0].arn
}
