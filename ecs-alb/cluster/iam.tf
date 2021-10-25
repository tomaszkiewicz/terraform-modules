module "iam_role_execution" {
  source = "../../iam/role"

  name = "ecs-execution-${var.cluster_name}"
  trusted_aws_services = [
    "ecs-tasks.amazonaws.com",
  ]
  attach_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
  policy = local.policy
}
