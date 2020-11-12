resource "aws_s3_bucket" "website" {
  bucket = local.bucket_name
  acl    = "private"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.website.iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${local.bucket_name}/*"
    }
  ]
}
EOF
  versioning {
    enabled = var.versioning
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  tags = {
    Name = local.bucket_name
  }
}
