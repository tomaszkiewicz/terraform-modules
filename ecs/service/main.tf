variable "cluster_id" {}
variable "subnet_ids" {}
variable "name" {}
variable "service_discovery_container_name" {}
variable "service_discovery_namespace_id" {}
variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "container_definitions" {}
variable "vpc_id" {}
variable "service_ports" {
  type = list
  default = [
    80,
  ]
}
variable "assign_public_ip" { default = false }
variable "initial_desired_count" { default = 1 }
variable "task_role_arn" { default = "" }
variable "execution_role_arn" { default = "" }

resource "aws_ecs_service" "service" {
  name             = var.name
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.task.arn
  desired_count    = var.initial_desired_count
  platform_version = "1.4.0"

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups = [
      module.sg.id,
    ]
    subnets = var.subnet_ids
  }

  service_registries {
    container_name = var.service_discovery_container_name
    registry_arn   = aws_service_discovery_service.service.arn
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

  name   = "ecs-service-${var.name}"
  vpc_id = var.vpc_id
  ports  = var.service_ports
}

resource "aws_service_discovery_service" "service" {
  name = var.name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_task_definition" "task" {
  family                = var.name
  network_mode          = "awsvpc"
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = var.container_definitions
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.execution_role_arn
  requires_compatibilities = [
    "FARGATE",
  ]
  #   <<EOF
  # [
  #   {
  #     "name": "nginx",
  #     "image": "nginx",
  #     "essential": true
  #   }
  # ]
  # EOF
  # "secrets": [
  #   {
  #     "name": "environment_variable_name",
  #     "valueFrom": "arn:aws:ssm:region:aws_account_id:parameter/parameter_name"
  #   }
  # ]


}
