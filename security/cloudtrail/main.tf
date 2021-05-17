variable "tenant" {}
# variable "kms_key_id" {}

module "bucket" {
  # source = "../../s3/encrypted-bucket"
  source = "../../s3/simple-bucket"

  bucket             = "${var.tenant}-cloudtrail"
  versioning_enabled = true

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
      "Resource": [
        "arn:aws:s3:::${var.tenant}-cloudtrail"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": [
        "arn:aws:s3:::${var.tenant}-cloudtrail/AWSLogs/*"
      ],
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

resource "aws_cloudtrail" "organization" {
  name                          = "organization"
  s3_bucket_name                = module.bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  # sns_topic_name                = "${data.terraform_remote_state.master.cloudtrail_events_sns_topic_arn}"
  enable_log_file_validation = true
  # kms_key_id                    = "${data.terraform_remote_state.master.kms_cloudtrail_arn["${var.account_name}"]}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = module.role.iam_role_arn

  depends_on = [
    aws_cloudwatch_log_group.cloudtrail,
  ]
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/AWS/Cloudtrail"
  retention_in_days = 7

  # kms_key_id = "${data.terraform_remote_state.master.kms_alias_cwlogs_arn["${var.account_name}"]}"
}

module "role" {
  source = "../../iam/role"

  name               = "cloudtrail"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  policy             = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogStream"
    ],
    "Resource": [
      "${aws_cloudwatch_log_group.cloudtrail.arn}"
    ]
  },
  {
    "Effect": "Allow",
    "Action": [
      "logs:PutLogEvents"
    ],
    "Resource": [
      "${aws_cloudwatch_log_group.cloudtrail.arn}"
    ]
  }
  ]
}
EOF

  depends_on = [
    aws_cloudwatch_log_group.cloudtrail,
  ]
}
