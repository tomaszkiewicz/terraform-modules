resource "aws_iam_user" "user" {
  name = var.name
  path = "/"
}

resource "aws_iam_user_policy_attachment" "attachment" {
  for_each = toset(var.attach_policies)

  user       = aws_iam_user.user.name
  policy_arn = each.value
}

resource "aws_iam_user_policy" "policy" {
  count = var.policy == "" ? 0 : 1

  user = aws_iam_user.user.name
  policy = var.policy
}