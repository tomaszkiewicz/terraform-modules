data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/ecs/${var.cluster_name}/*"
    ]
  }
}