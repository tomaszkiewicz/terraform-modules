module "config_bucket" {
  source = "../../s3/simple-bucket"

  bucket             = "${var.tenant}-aws-config"
  versioning_enabled = true
  enable_expiration  = true

  // TODO probably requires condition to check OrgId
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": " AWSConfigBucketDelivery",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "config.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.tenant}-aws-config/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSConfigBucketPermissionsCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "config.amazonaws.com"
        ]
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.tenant}-aws-config"
    }
  ]
}
EOF
}
