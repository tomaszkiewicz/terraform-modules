resource "aws_s3_bucket" "website" {
  count = var.external_bucket_endpoint != "" ? 0 : 1

  bucket = local.bucket_name
  acl = "public-read"
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*"
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