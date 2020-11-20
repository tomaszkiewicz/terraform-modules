locals {
  policy = var.policy != "" ? var.policy : <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:${data.aws_partition.current.partition}:s3:::${var.bucket}/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:${data.aws_partition.current.partition}:s3:::${var.bucket}/*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      }
    },
    {
      "Sid": "AllowSSLRequestsOnly",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": [
        "arn:${data.aws_partition.current.partition}:s3:::${var.bucket}",
        "arn:${data.aws_partition.current.partition}:s3:::${var.bucket}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.bucket
  }

  versioning {
    enabled = var.versioning_enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging_target_bucket == null ? [] : [""]
    content {
      target_bucket = var.logging_target_bucket
      target_prefix = var.logging_target_prefix
    }
  }

  policy = local.policy

  lifecycle_rule {
    enabled = var.enable_transition

    transition {
      days          = var.days_to_transition
      storage_class = var.transition_storage_class
    }
  }

  lifecycle_rule {
    enabled = var.enable_expiration

    expiration {
      days = var.days_to_expiration
    }
  }
}
