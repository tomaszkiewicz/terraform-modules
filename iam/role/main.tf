locals {
  assume_role_policy = var.assume_role_policy != "" ? var.assume_role_policy : <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          ${join(",", formatlist("\"%s\"", var.trusted_aws_principals))}
        ],
        "Service": [
          ${join(",", formatlist("\"%s\"", var.trusted_aws_services))}
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "role" {
  name                 = var.name
  assume_role_policy   = local.assume_role_policy
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy" "policy" {
  name   = var.name
  role   = aws_iam_role.role.id
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "attachment" {
  for_each = toset(var.attach_policies)

  role       = aws_iam_role.role.name
  policy_arn = each.value
}
