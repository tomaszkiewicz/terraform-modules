locals {
  principals = concat(
    list("arn:aws:iam::${var.master_aws_account_id}:user/ci-deployer"),
    var.additional_principals,
  )
}

module "deployer" {
  source = "../../iam/role"

  name               = "deployer"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          ${join(",", formatlist("\"%s\"", local.principals))}
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  policy = var.policy
}

