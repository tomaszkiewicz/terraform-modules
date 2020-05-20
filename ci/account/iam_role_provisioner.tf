locals {
  provisioner_principals = concat(
    list("arn:aws:iam::${var.master_aws_account_id}:user/ci-provisioner"),
    var.provisioner_additional_principals,
  )
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
  ]
}
EOF
  attach_policies = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/job-function/Billing",
  ]
}

