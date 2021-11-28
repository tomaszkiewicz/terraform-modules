resource "aws_ecs_service" "service" {
  name                   = var.name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.task.arn
  desired_count          = var.initial_desired_count
  platform_version       = "1.4.0"
  enable_execute_command = true

  dynamic "network_configuration" {
    for_each = var.enable_fargate ? ["hack"] : []
    content {
      assign_public_ip = var.assign_public_ip
      security_groups = [
        module.sg[0].id,
      ]
      subnets = var.subnet_ids
    }
  }

  dynamic "load_balancer" {
    for_each = var.lb_listener_arn != "" || var.lb_force_create_target_group ? ["hack"] : []
    content {
      target_group_arn = join("", aws_lb_target_group.ecs.*.arn)
      container_name   = var.service_discovery_container_name
      container_port   = var.service_port
    }
  }

  dynamic "service_registries" {
    for_each = var.service_discovery_namespace_id == "" ? [] : ["hack"]
    content {
      container_name = var.service_discovery_container_name
      registry_arn   = join("", aws_service_discovery_service.service.*.arn)
      container_port = var.service_port
    }
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  # lifecycle {
  #   ignore_changes = [
  #     desired_count,
  #   ]
  # }
}

module "sg" {
  source = "github.com/tomaszkiewicz/terraform-modules/sg"
  count  = var.enable_fargate ? 1 : 0

  name   = "ecs-service-${var.name}"
  vpc_id = var.vpc_id
  ports = [
    var.service_port,
  ]
}

resource "aws_service_discovery_service" "service" {
  count = var.service_discovery_namespace_id != "" ? 1 : 0

  name = var.name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 1
      type = "A"
    }

    dns_records {
      ttl  = 1
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  # health_check_config {
  #   type = "HTTP"
  # }

  # health_check_custom_config {
  #   failure_threshold = 1
  # }
}

data "aws_ecs_container_definition" "existing" {
  count = var.container_image_tag == "" ? 1 : 0

  task_definition = var.name
  container_name  = var.service_discovery_container_name
}

resource "aws_ecs_task_definition" "task" {
  family             = var.name
  network_mode       = var.enable_fargate ? "awsvpc" : null
  cpu                = var.cpu
  memory             = var.memory
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  requires_compatibilities = var.enable_fargate ? [
    "FARGATE",
  ] : []

  container_definitions = jsonencode(flatten([
    merge(
      {
        name : var.service_discovery_container_name
        image : "${var.container_image}:${var.container_image_tag == "" ? data.aws_ecs_container_definition.existing[0].image_digest : var.container_image_tag}"
        essential : true
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
      },
      !var.enable_fargate  ? {} : {
        logConfiguration : {
          logDriver : "awslogs"
          options : {
            awslogs-group : aws_cloudwatch_log_group.service.name
            awslogs-region : data.aws_region.current.name
            awslogs-stream-prefix : var.service_discovery_container_name
          }
        },
      }
      length(var.entryPoint) == 0 ? {} : {
        entryPoint : var.entryPoint
      },
      length(var.command) == 0 ? {} : {
        command : var.command
      },
    ),
    var.health_check_path != "" && (var.lb_listener_arn == "" && ! var.lb_force_create_target_group) ? [{
      name : "healthcheck"
      image : "luktom/ws"
      essential : true
      healthCheck : {
        command : [
          "CMD-SHELL",
          "curl -s -f http://localhost:${var.health_check_port != "" ? var.health_check_port : var.service_port}${var.health_check_path} || exit 1"
        ]
        retries : var.health_check_retries
        timeout : var.health_check_timeout
        interval : var.health_check_interval
        startPeriod : var.health_check_start_period
      }
      command : [
        "pause"
      ]
    }] : []
    ])
  )
}
