resource "aws_ecs_service" "service" {
  name                   = var.name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.task.arn
  desired_count          = var.initial_desired_count
  platform_version       = var.enable_fargate ? "1.4.0" : null
  enable_execute_command = true
  launch_type            = var.enable_fargate ? "FARGATE" : "EC2"
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

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

  dynamic "capacity_provider_strategy" {
    for_each = var.enable_fargate ? ["hack"] : []
    content {
      base              = 0
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
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
