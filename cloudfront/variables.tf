variable "domain_name" {}
variable "target_server_domain_name" {}
variable "force_https" { default = true }
variable "certificate_arn" {}
variable "origin_protocol_policy" { default = "http-only" }
variable "default_ttl" { default = 0 }
variable "min_ttl" { default = 0 }
variable "max_ttl" { default = 0 }
variable "additional_domain_names" {
  type    = list(string)
  default = []
}

variable "lambda_viewer_request" { default = "" }
variable "skip_www" { default = false }
