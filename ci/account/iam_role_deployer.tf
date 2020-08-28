locals {
  deployer_principals = concat(
    list("arn:${data.aws_partition.current.partition}:iam::${var.master_aws_account_id}:user/ci-deployer"),
    var.deployer_additional_principals,
  )
}

module "ci_deployer" {
  source = "../../iam/role"

  name               = "ci-deployer"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          ${join(",", formatlist("\"%s\"", local.deployer_principals))}
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  policy = var.deployer_policy
}

resource "aws_iam_role_policy" "additional" {
  count = var.deployer_additional_policy == "" ? 0 : 1

  role = module.ci_deployer.name
  policy = var.deployer_additional_policy
}