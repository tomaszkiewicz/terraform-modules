variable "domain_name" {}
variable "additional_alias" {default = ""}
variable "dns_zone_id" { default = "" }
variable "certificate_arn" {}
variable "versioning" { default = false }
variable "bucket_name" { default = "" }
variable "skip_www" { default = false }
variable "create_dns_record" { default = true }

variable "index_document_on_404" { default = false }
variable "index_document" { default = "index.html" }
variable "error_document" { default = "error404/index.html" }

variable "min_ttl" { default = 0 }
variable "default_ttl" { default = 1800 }
variable "max_ttl" { default = 3600 }

variable "retain_on_delete" { default = false }

variable "lambda_viewer_request" { default = "" }

locals {
  bucket_name = var.bucket_name == "" ? var.domain_name : var.bucket_name
}
variable "cloudfront_ordered_cache_behavior" {
  default     = {}
  description = "Ordered cache behavior dynamic pool"
}
variable "cloudfront_origin_custom" {
  default     = {}
  description = "Definition of origins with custom origin config"
}