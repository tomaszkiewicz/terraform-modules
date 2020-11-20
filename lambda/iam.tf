resource "aws_lambda_permission" "principal" {
  for_each = toset(var.invoke_allow_principals)

  statement_id  = replace(each.value, "/[\\.:\\/]/", "_")
  action        = "lambda:InvokeFunction"
  function_name = join("", aws_lambda_function.lambda_source_dir.*.function_name, aws_lambda_function.lambda_external.*.function_name, aws_lambda_function.lambda_source_file.*.function_name)
  principal     = each.value
}

resource "aws_iam_policy" "lambda" {
  name   = "lambda-${var.name}"
  policy = var.additional_policy
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = module.lambda_role.name
  policy_arn = aws_iam_policy.lambda.arn
}

module "lambda_role" {
  source = "../iam/role"

  name               = "lambda-${var.name}"
  assume_role_policy = var.assume_role_policy
  policy             = var.policy
  attach_policies    = var.attach_policies
}
