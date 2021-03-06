module "deployer" {
  source = "../../iam/user"

  name = "ci-deployer"
}

module "deployer_group" {
  source = "../../iam/group"

  name = "ci-deployer"
  members = [
    module.deployer.name,
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
      "Resource": "arn:${data.aws_partition.current.partition}:iam::*:role/ci-deployer"
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
        "ssm:GetParameter*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
