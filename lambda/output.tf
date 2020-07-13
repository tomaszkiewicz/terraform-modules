output "arn" {
  value = join("",
    aws_lambda_function.lambda_external.*.arn,
    aws_lambda_function.lambda_source_dir.*.arn,
    aws_lambda_function.lambda_source_file.*.arn,
  )
}

output "version" {
  value = join("",
    aws_lambda_function.lambda_external.*.version,
    aws_lambda_function.lambda_source_dir.*.version,
    aws_lambda_function.lambda_source_file.*.version,
  )
}

output "function_name" {
  value = var.name
}

output "name" {
  value = var.name
}

output "iam_role_arn" {
  value = module.lambda_role.iam_role_arn
}

output "iam_role_name" {
  value = module.lambda_role.name
}

output "invoke_arn" {
  value = join("",
    aws_lambda_function.lambda_external.*.invoke_arn,
    aws_lambda_function.lambda_source_dir.*.invoke_arn,
    aws_lambda_function.lambda_source_file.*.invoke_arn,
  )
}

output "arn" {
  value = join("",
    aws_lambda_function.lambda_external.*.arn,
    aws_lambda_function.lambda_source_dir.*.arn,
    aws_lambda_function.lambda_source_file.*.arn,
  )
}