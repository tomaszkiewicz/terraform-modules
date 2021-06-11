resource "aws_ecs_service" "service" {
  name = var.name
  cluster = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = var.initial_desired_count
  platform_version = "1.4.0"

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups = [module.sg.id] // SG allow from ALB
    subnets = var.subnet_ids  //private
  }

  load_balancer {
    target_group_arn = var.alb_target_group  //balancer
    container_name = var.image_name
    container_port = var.service_port
  }

  capacity_provider_strategy {
    base = 0
    capacity_provider = "FARGATE_SPOT"
    weight = 1
  }

  # lifecycle {
  #   ignore_changes = [
  #     desired_count,
  #   ]
  # }

}




module "sg" {
  source = "github.com/pragmaticcoders/terraform-modules/sg"

  name   = "ecs-service-${var.name}"
  vpc_id = var.vpc_id
  ports = [
    var.service_port,var.health_check_port,
  ]
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

  container_definitions = jsonencode([
    merge(
      {
        name : var.image_name
        image : var.container_image
        essential : true
        stopTimeout: 10
        portMappings : [
          {
            hostPort : var.service_port
            protocol : "tcp"
            containerPort : var.service_port
          },
        ]
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
            awslogs-stream-prefix : var.container_image
          }
        },
      },
      length(var.entryPoint) == 0 ? {} : {
        entryPoint : var.entryPoint
      },
      length(var.command) == 0 ? {} : {
        command : var.command
      },
    ),
  ])
}
