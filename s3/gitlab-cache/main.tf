resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = "private"

  tags = {
    Name = var.bucket
  }

  lifecycle_rule {
    id      = "cache"
    enabled = true

    prefix = "/"

    expiration {
      days = var.expiration_days
    }
  }
}
