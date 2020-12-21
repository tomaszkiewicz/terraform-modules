locals {
  provisioner_principals = concat(
    list("arn:${data.aws_partition.current.partition}:iam::${var.master_aws_account_id}:user/ci-provisioner"),
    var.provisioner_additional_principals,
  )
  sso_trust_policy = <<EOF
  ,
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:${data.aws_partition.current.partition}:iam::${var.sso_account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": [
            "arn:${data.aws_partition.current.partition}:iam::${var.sso_account_id}:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_${var.sso_role_name}_*",
            "arn:${data.aws_partition.current.partition}:iam::${var.sso_account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_${var.sso_role_name}_*"
          ]
        }
      }
    }
EOF
}

module "ci_provisioner" {
  source = "../../iam/role"

  name               = "ci-provisioner"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          ${join(",", formatlist("\"%s\"", local.provisioner_principals))}
        ]
      },
      "Action": "sts:AssumeRole"
    }
    ${var.sso_trust_enabled ? local.sso_trust_policy : ""}
  ]
}
EOF
  attach_policies = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AdministratorAccess",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/job-function/Billing",
  ]
}

