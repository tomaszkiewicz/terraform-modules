module "iam_role_gitlab_runner" {
  source = "../iam/role"

  name = "gitlab-runner-manager"
  trusted_aws_services = [
    "ecs-tasks.amazonaws.com",
  ]
  attach_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
  ]
}