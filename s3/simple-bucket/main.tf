resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = var.acl

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.bucket
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "logging" {
    for_each = var.logging_target_bucket == null ? [] : [""]
    content {
      target_bucket = var.logging_target_bucket
      target_prefix = var.logging_target_prefix
    }
  }

  policy = var.policy

  lifecycle_rule {
    enabled = var.enable_transition

    transition {
      days          = var.days_to_transition
      storage_class = var.transition_storage_class
    }
  }

  dynamic "cors_rule" {
    for_each = var.enable_cors ? [""] : []
    content {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  }

  lifecycle_rule {
    enabled = var.enable_expiration

    expiration {
      days = var.days_to_expiration
    }
  }
}
