resource "aws_lambda_layer_version" "rds_ca" {
  filename   = "/tmp/terraform-artifacts/lambda-layer-rds-ca.zip"
  layer_name = var.layer_name

  compatible_runtimes = [
    "nodejs10.x",
    "nodejs12.x",
    "go1.x",
  ]
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = "${path.module}/layer"
  output_path = "/tmp/terraform-artifacts/lambda-layer-rds-ca.zip"
}
