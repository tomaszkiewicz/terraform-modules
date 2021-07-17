variable "name_suffix" {}

module "role" {
  source = "../../iam/role"

  name = "ecs-service-exec-${var.name_suffix}"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
  })
  trusted_aws_services = [
    "ecs-tasks.amazonaws.com",
  ]
}

output "arn" {
  value = module.role.arn
}

output "name" {
  value = module.role.name
}