resource "aws_iam_group" "group" {
  name = var.name
  path = "/"
}

resource "aws_iam_user_group_membership" "user" {
  for_each = toset(var.members)

  user = each.key
  groups = [
    aws_iam_group.group.name,
  ]
}

resource "aws_iam_group_policy" "group" {
  count = var.policy == "" ? 0 : 1

  name   = var.name
  group  = aws_iam_group.group.id
  policy = var.policy
}

resource "aws_iam_group_policy_attachment" "policy" {
  for_each = toset(var.attach_policies)

  group      = aws_iam_group.group.name
  policy_arn = each.key
}
