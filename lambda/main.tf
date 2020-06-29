resource "aws_lambda_function" "lambda_source_dir" {
  count = var.source_dir != "" ? 1 : 0

  function_name    = var.name
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  role             = module.lambda_role.arn
  handler          = var.handler
  timeout          = var.timeout
  runtime          = var.runtime
  publish          = var.publish
  memory_size      = var.memory_size
  layers           = var.layers
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }

  environment {
    variables = var.environment
  }

  lifecycle {
    ignore_changes = [
      last_modified,
    ]
  }
}

resource "aws_lambda_function" "lambda_external" {
  count = var.source_dir == "" ? 1 : 0

  function_name    = var.name
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  role             = module.lambda_role.arn
  handler          = var.handler
  timeout          = var.timeout
  runtime          = var.runtime
  publish          = var.publish
  memory_size      = var.memory_size
  layers           = var.layers
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }

  environment {
    variables = var.environment
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      last_modified,
      layers,
    ]
  }
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = var.source_dir != "" ? var.source_dir : "${path.module}/default"
  output_path = "/tmp/terraform-artifacts/lambda-${var.name}.zip"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.logs_retention_days
}
