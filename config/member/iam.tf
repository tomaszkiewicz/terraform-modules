module "role" {
  source = "../../iam/role"

  name = "aws-config"
  trusted_aws_services = [
    "config.amazonaws.com",
  ]
  attach_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "config:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "cloudtrail:DescribeTrails",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "kms:DescribeKey",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.config_logs_bucket}/${var.config_logs_prefix}/AWSLogs/${var.account_id}/*"
      ],
      "Condition": {
        "StringLike": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketAcl"
      ],
      "Resource": "arn:aws:s3:::${var.config_logs_bucket}"
    }
  ]
}
EOF
}
