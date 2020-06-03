module "cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.1"

  allow_headers     = var.allow_headers
  allow_methods     = var.allow_methods
  allow_origin      = var.allow_origin
  allow_max_age     = var.allow_max_age
  allow_credentials = var.allow_credentials
  api_id            = var.api_id
  api_resource_id   = var.api_resource_id
}
