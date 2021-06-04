module "iam_role_execution" {
  source = "../../iam/role"

  name = "ecs-execution-${var.cluster_name}"
  trusted_aws_services = [
    "ecs-tasks.amazonaws.com",
  ]
  attach_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": [
        "arn:aws:ssm:*:*:parameter/ecs/${var.cluster_name}/*"
      ]
    }
  ]
}
EOF
}
