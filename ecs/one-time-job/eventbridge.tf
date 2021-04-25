# resource "aws_cloudwatch_event_rule" "rule" {
#   name = "ecs-job-${var.name}"
# }

# resource "aws_cloudwatch_event_target" "esc_target" {
#   target_id = var.name
#   arn       = var.cluster_arn
#   rule      = aws_cloudwatch_event_rule.rule.name
#   role_arn  = module.role.arn

#   ecs_target {
#     task_count          = 1
#     task_definition_arn = aws_ecs_task_definition.task.arn
#     launch_type         = "FARGATE"
#     platform_version    = "1.4.0"

#     network_configuration {
#       assign_public_ip = var.assign_public_ip
#       security_groups = [
#         module.sg.id,
#       ]
#       subnets = var.subnet_ids
#     }
#   }
# }

# module "role" {
#   source = "../../iam/role"

#   name = "ecs-job-${var.name}"
#   trusted_aws_services = [
#     "events.amazonaws.com",
#   ]
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "ecs:RunTask",
#           ],
#           "Resource" : [
#             replace(aws_ecs_task_definition.task.arn, "/:${aws_ecs_task_definition.task.revision}$$/", ":*"),
#           ],
#           "Condition" : {
#             "test" : "StringLike"
#             "variable" : "ecs:cluster"
#             "values" : [var.cluster_arn]
#           }
#         },
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "iam:PassRole",
#           ],
#           "Resource" : [
#             var.execution_role_arn,
#             var.task_role_arn,
#           ]
#         }
#       ]
#   })
# }
