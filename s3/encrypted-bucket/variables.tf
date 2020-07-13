variable "bucket" {}
variable "kms_key_id" {}
variable "versioning_enabled" { default = false }
variable "logging_target_bucket" { default = null }
variable "logging_target_prefix" { default = null }
