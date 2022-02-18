resource "aws_ecs_service" "service" {
  name = var.name
  cluster = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = var.initial_desired_count
  enable_execute_command = var.enable_execute_command
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

  dynamic "load_balancer" {
    for_each = var.load_balancer == "" ? {} : { for k, v in var.load_balancer : k => v }
    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.key
      container_port   = load_balancer.value["container_port"]
    }
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
data "aws_ecs_container_definition" "existing" {
  count = var.container_image_tag == "" ? 1 : 0

  task_definition = var.name
  container_name  = var.image_name
}



module "sg" {
  source = "github.com/pragmaticcoders/terraform-modules/sg"

  name   = "ecs-service-${var.image_name}"
  vpc_id = var.vpc_id
  ports  = local.sg_ports
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
  dynamic "volume" {
    for_each = var.efs_mount == "" ? {} : { for k, v in var.efs_mount : k => v }
    content {
      name = volume.key
      efs_volume_configuration {
        root_directory          = volume.value["root_directory"]
        file_system_id          = volume.value["file_system_id"]
        transit_encryption      = "ENABLED"
        transit_encryption_port = volume.value["transit_encryption_port"] == "" ? 2999 : volume.value["transit_encryption_port"]
        authorization_config {
          access_point_id = volume.value["access_point_id"]
          iam             = "ENABLED"
        }
      }
    }
  }

  container_definitions = jsonencode(concat([
    merge(
      {
        name : var.image_name
        image : "${var.container_image}:${var.container_image_tag == "" ? data.aws_ecs_container_definition.existing[0].image_digest : var.container_image_tag}"
        essential : true
        stopTimeout: 10
        portMappings : var.portMappings != "" ? var.portMappings : local.singlePort
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
        mountPoints : [
          for k, v in var.mount_points : {
            sourceVolume : v["sourceVolume"]
            containerPath : v["containerPath"]
            readOnly : v["readOnly"]
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
    )
  ], var.sidecar_definitions))
}
