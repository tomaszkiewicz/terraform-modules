variable "domain_name" {}
variable "api_gateway_invoke_url" {}
variable "retain_on_delete" { default = false }
variable "certificate_arn" {}
variable "min_ttl" { default = 0 }
variable "default_ttl" { default = 1800 }
variable "max_ttl" { default = 3600 }
variable "create_dns_record" { default = true }
variable "dns_zone_id" { default = "" }
variable "lambda_viewer_request" { default = "" }