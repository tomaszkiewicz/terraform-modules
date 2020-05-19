locals {
  file_hashes = [
    md5(file("${path.module}/main.tf")),
    md5(file("${path.module}/base.tf")),
  ]
  combined_hash = join(",", local.file_hashes)
}

resource "aws_api_gateway_rest_api" "api" {
  name = var.name
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name

  variables = {
    #deployed_at = timestamp()
    tf_recreate_hash = local.combined_hash
  }

  depends_on = [
    aws_api_gateway_method.lambda,
  ]
}
