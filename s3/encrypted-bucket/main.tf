resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl = "private"

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
    "rule" {
      "apply_server_side_encryption_by_default" {
        kms_master_key_id = var.kms_key_id
        sse_algorithm = "aws:kms"
      }
    }
  }

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.bucket}/*",
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
      "Resource": "arn:aws:s3:::${var.bucket}/*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": true
        }
      }
    },
    {
      "Effect":"Allow",
      "Principal": {
        "AWS": [
          "${module.provisioner_role.arn}"
        ]
      },
      "Action": [
        "s3:*"
      ],
      "Resource": "arn:aws:s3:::ifds-${lower(var.account_name)}-backup/*"
    }
  ]
}
EOF
}
