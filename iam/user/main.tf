resource "aws_iam_user" "user" {
  count = var.create ? 1 : 0

  name = var.name
  path = "/"
}

resource "aws_iam_user_policy_attachment" "attachment" {
  for_each = var.create ? toset(var.attach_policies) : []

  user       = var.name
  policy_arn = each.value

  depends_on = [
    aws_iam_user.user,
  ]
}

resource "aws_iam_user_policy" "policy" {
  count = var.policy != "" && var.create ? 1 : 0

  user   = var.name
  policy = var.policy

  depends_on = [
    aws_iam_user.user,
  ]
}
