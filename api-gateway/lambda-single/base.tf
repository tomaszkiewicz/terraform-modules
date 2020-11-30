locals {
  file_hashes = [
    md5(file("${path.module}/main.tf")),
    md5(file("${path.module}/base.tf")),
  ]
  combined_hash = join(",", concat(local.file_hashes, var.external_recreate_hashes))
}

resource "aws_api_gateway_rest_api" "api" {
  name = var.name
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name

  variables = {
    #deployed_at = timestamp()
    tf_recreate_hash     = local.combined_hash
    name                 = var.name
    stage_name           = var.stage_name
    lambda_function_name = var.lambda_function_name
    lambda_invoke_arn    = var.lambda_invoke_arn
    authorization        = var.authorization
    authorizer_id        = var.authorizer_id
  }

  depends_on = [
    aws_api_gateway_method.lambda,
    aws_api_gateway_integration.lambda,
  ]

  lifecycle {
    create_before_destroy = true
  }
}
