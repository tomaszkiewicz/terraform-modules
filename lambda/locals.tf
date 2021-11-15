locals {
  layers = concat(
    var.layers,
    var.enable_lambda_insights ? [
      "arn:aws:lambda:${data.aws_region.current.name}:580247275435:layer:LambdaInsightsExtension:${var.lambda_insights_version}",
    ] : [],
    var.enable_lambda_layers_rds_ca ? [ module.lambda_layer_rds_ca.arn ] : []
  )
}
