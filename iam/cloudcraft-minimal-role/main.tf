module "role" {
  source = "../role"
  name   = "cloudcraft-minimal-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::968898580625:root"
            ]
          },
          "Condition" : {
            "StringEquals" : {
              "sts:ExternalId" : "6cb3d6ab-812b-481f-8688-6b23a7df533b"
            }
          }
        }
      ]
    }
  )
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "apigateway:Get",
            "autoscaling:Describe*",
            "cloudfront:Get*",
            "cloudfront:List*",
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*",
            "dynamodb:DescribeTable",
            "dynamodb:ListTables",
            "dynamodb:ListTagsOfResource",
            "ec2:Describe*",
            "ecr:Describe*",
            "ecr:List*",
            "ecs:Describe*",
            "ecs:List*",
            "eks:Describe*",
            "eks:List*",
            "elasticache:Describe*",
            "elasticache:List*",
            "elasticfilesystem:Describe*",
            "elasticloadbalancing:Describe*",
            "es:Describe*",
            "es:List*",
            "fsx:Describe*",
            "fsx:List*",
            "kinesis:Describe*",
            "kinesis:List*",
            "lambda:List*",
            "rds:Describe*",
            "rds:ListTagsForResource",
            "redshift:Describe*",
            "route53:Get*",
            "route53:List*",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation",
            "s3:GetBucketNotification",
            "s3:GetBucketTagging",
            "s3:GetEncryptionConfiguration",
            "s3:List*",
            "ses:Get*",
            "ses:List*",
            "sns:GetTopicAttributes",
            "sns:List*",
            "sqs:GetQueueAttributes",
            "sqs:ListQueues",
            "sqs:ListQueueTags",
            "tag:Get*",
            "wafv2:GetWebACL*",
            "wafv2:List*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
}
