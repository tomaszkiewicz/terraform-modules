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
        memory : var.memory // required e.g. for ecs-deploy script
        portMappings : var.port_mappings != null ? var.port_mappings : (var.service_port > 0 ? [
          {
            hostPort : var.service_port
            protocol : "tcp"
            containerPort : var.service_port
          },
        ] : []),
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
      ! var.enable_fargate ? {} : {
        logConfiguration : {
          logDriver : "awslogs"
          options : {
            awslogs-group : aws_cloudwatch_log_group.service.name
            awslogs-region : data.aws_region.current.name
            awslogs-stream-prefix : var.service_discovery_container_name
          }
        },
      },
      length(var.entryPoint) == 0 ? {} : {
        entryPoint : var.entryPoint
      },
      length(var.command) == 0 ? {} : {
        command : var.command
      },
      var.ecs_config_content == "" ? {} : {
        dependsOn : [
          {
            containerName : "ecs-file-composer",
            condition : "SUCCESS"
          }
        ]
        mountPoints : [
          {
            containerPath : var.config_path
            sourceVolume : "config"
          },
        ]
      }
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
    }] : [],
    var.ecs_config_content == "" ? [] : [{
      name : "ecs-file-composer"
      image : "public.ecr.aws/compose-x/ecs-files-composer"
      essential : false
      memory : 50
      mountPoints : [
        {
          containerPath : var.config_path
          sourceVolume : "config"
        },
      ]
      environment : [
        {
          name : "ECS_CONFIG_CONTENT"
          value : var.ecs_config_content
        }
      ]
    }],
    ])
  )

  dynamic "volume" {
    for_each = var.ecs_config_content != "" ? ["hack"] : []
    content {
      name = "config"
    }
  }
}
