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

  lifecycle_rule {
    id      = "cache"
    enabled = true

    prefix = "/"

    expiration {
      days = 30
    }
  }
}
