# resource "aws_ecs_service" "service" {
#   name                   = var.name
#   cluster                = var.cluster_id
#   task_definition        = aws_ecs_task_definition.task.arn
#   desired_count          = var.initial_desired_count
#   platform_version       = "1.4.0"
#   enable_execute_command = true

#   network_configuration {
#     assign_public_ip = var.assign_public_ip
#     security_groups = [
#       module.sg.id,
#     ]
#     subnets = var.subnet_ids
#   }
# }

// for egress traffic, to be refactored in the future
module "sg" {
  source = "github.com/tomaszkiewicz/terraform-modules/sg"

  name   = "ecs-job-${var.name}"
  vpc_id = var.vpc_id
  ports  = []
}

data "aws_ecs_container_definition" "existing" {
  count = var.container_image_tag == "" ? 1 : 0

  task_definition = var.name
  container_name  = "app"
}

resource "aws_ecs_task_definition" "task" {
  family             = var.name
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  requires_compatibilities = [
    "FARGATE",
  ]

  container_definitions = jsonencode(flatten(
    [
      merge(
        {
          name : "app"
          image : "${var.container_image}:${var.container_image_tag == "" ? data.aws_ecs_container_definition.existing[0].image_digest : var.container_image_tag}"
          essential : true
          environment : [
            for k, v in var.environment : {
              name : k
              value : v
            }
          ]
          secrets : [
            for k, v in var.secrets : {
              name : k
              valueFrom : v
            }
          ]
          logConfiguration : {
            logDriver : "awslogs"
            options : {
              awslogs-group : aws_cloudwatch_log_group.service.name
              awslogs-region : data.aws_region.current.name
              awslogs-stream-prefix : "app"
            }
          },
        },
        length(var.entryPoint) == 0 ? {} : {
          entryPoint : var.entryPoint
        },
        length(var.command) == 0 ? {} : {
          command : var.command
        },
      )
    ]
  ))
}
