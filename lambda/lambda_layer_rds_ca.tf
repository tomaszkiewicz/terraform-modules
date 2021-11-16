module "lambda_layer_rds_ca" {
  count  = var.enable_lambda_layers_rds_ca != "" ? 1 : 0
  source = "./layers/rds-ca"
  layer_name = var.lambda_layer_rds_ca_name
}