variable "kms_key_id" {}
variable "tenant" {}
variable "is_multi_region_trail" { default = true }
variable "is_organization_trail" { default = true }
variable "s3_enable_transition" { default = true }
variable "s3_days_to_transition" { default = 14 }
variable "s3_transition_storage_class" { default = "GLACIER" }
variable "s3_enable_expiration" { default = false }
variable "s3_days_to_expiration" { default = 90 }

locals {
  bucket = "${var.tenant}-cloudtrail"
}

module "s3_bucket" {
  source = "../s3/encrypted-bucket"

  bucket             = local.bucket
  versioning_enabled = true
  kms_key_id         = var.kms_key_id

  enable_transition        = var.s3_enable_transition
  days_to_transition       = var.s3_days_to_transition
  transition_storage_class = var.s3_transition_storage_class
  enable_expiration        = var.s3_enable_expiration
  days_to_expiration       = var.s3_days_to_expiration

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.bucket}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.bucket}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF
}

resource "aws_cloudtrail" "main" {
  name           = "main"
  s3_bucket_name = module.s3_bucket.bucket

  is_multi_region_trail = var.is_multi_region_trail
  is_organization_trail = var.is_organization_trail
  kms_key_id            = var.kms_key_id
}
