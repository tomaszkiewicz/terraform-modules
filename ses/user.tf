module "user" {
  source = "../iam/user"

  name = "ses"
  create = var.create_user
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:SendRawEmail",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "ses" {
  count = var.create_user ? 1 : 0

  user = module.user.name
}
