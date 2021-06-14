variable "master_aws_account_id" {}
variable "deployer_additional_principals" {
  type    = list
  default = []
}
variable "provisioner_additional_principals" {
  type = list
  default = []
}
variable "deployer_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*Object*",
        "s3:*List*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:PublishLayerVersion",
        "lambda:InvokeFunction"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

variable "deployer_additional_policy" { default = "" }

# all variables have to be set when sso_trust_enabled = true
variable "sso_trust_enabled" { default = false }
variable "sso_account_id" { default = "" }
variable "sso_role_name" { default = "AdministratorAccess" }
