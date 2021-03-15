variable "api" { default = "" }

module "api-gateway" {
  source = "./api-gateway"

  api_name = var.api
}
