variable "kms_key_id" {}
variable "tenant" {}
variable "is_multi_region_trail" { default = true }
variable "is_organization_trail" { default = true }
variable "s3_enable_transition" { default = true }
variable "s3_days_to_transition" { default = 14 }
variable "s3_transition_storage_class" { default = "GLACIER" }
variable "s3_enable_expiration" { default = false }
variable "s3_days_to_expiration" { default = 90 }
