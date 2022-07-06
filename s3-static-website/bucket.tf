resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  acl    = "private"
  
  versioning {
    enabled = var.versioning
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  tags = {
    Name = var.bucket_name
  }
}
