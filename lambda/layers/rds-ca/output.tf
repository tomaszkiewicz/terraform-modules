output "arn" {
  value = aws_lambda_layer_version.rds_ca.arn
}

output "layer_arn" {
  value = aws_lambda_layer_version.rds_ca.layer_arn
}