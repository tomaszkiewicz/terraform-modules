variable "domain_name" {}
variable "dns_zone_id" { default = "" }
variable "certificate_arn" {}
variable "versioning" { default = false }
variable "bucket_name" { default = "" }
variable "skip_www" { default = false }
variable "create_dns_record" { default = true }

variable "index_document" { default = "index.html" }
variable "error_document" { default = "error404/index.html" }
variable "external_bucket_name" { default = "" }
variable "external_bucket_endpoint" { default = "" }

variable "min_ttl" { default = 0 }
variable "default_ttl" { default = 1800 }
variable "max_ttl" { default = 3600 }

variable "retain_on_delete" { default = false }

locals {
  bucket_name = "${var.external_bucket_name != "" ? var.external_bucket_name : (var.bucket_name == "" ? var.domain_name : var.bucket_name)}"
}