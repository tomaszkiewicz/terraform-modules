module "provisioner" {
  source = "../../iam/user"

  name = "ci-provisioner"
}

module "provisioner_group" {
  source = "../../iam/group"

  name = "ci-provisioner"
  members = [
    module.provisioner.name,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": "arn:${data.aws_partition.current.partition}:iam::*:role/ci-provisioner"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
