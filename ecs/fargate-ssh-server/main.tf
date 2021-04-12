resource "aws_ecs_service" "service" {
  name             = var.name
  cluster          = var.cluster_arn
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

  dynamic "service_registries" {
    for_each = var.service_discovery_namespace_id == "" ? [] : [""]
    content {
      container_name = "app"
      registry_arn   = aws_service_discovery_service.service[0].arn
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

resource "aws_service_discovery_service" "service" {
  count = var.service_discovery_namespace_id == "" ? 0 : 1

  name = var.name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }
}

module "sg" {
  source = "github.com/pragmaticcoders/terraform-modules/sg"

  name   = "ecs-service-${var.name}"
  vpc_id = var.vpc_id
  ports = [
    var.service_port,
  ]

  cidr_blocks = var.cidr_blocks

}

resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/service/${var.name}"
  retention_in_days = var.logs_retention_days
}

resource "aws_ecs_task_definition" "task" {
  family             = var.name
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  # task_role_arn      = module.task_role.arn
  requires_compatibilities = [
    "FARGATE",
  ]

  container_definitions = jsonencode([
    merge({
      name : "app"
      image : "${var.container_image}:${var.container_image_tag}"
      essential : true
      portMappings : [
        {
          hostPort : var.service_port
          protocol : "tcp"
          containerPort : var.service_port
        },
      ]
      environment : concat([
        ], [
        for k, v in var.environment : {
          name : k
          value : v
        }
      ])
      secrets : concat([
        ], [
        for k, v in var.secrets : {
          name : k
          valueFrom : v
        }
      ])
      entryPoint : [
        "/usr/bin/sudo",
        "-E",
        "/bin/bash",
        "-c",
      ]
      command : [
        join(" && ", [
          "apk add --update openssh",
          "ssh-keygen -A",
          "sed -i \"s/.*PermitRootLogin.*/PermitRootLogin without-password/g\" /etc/ssh/sshd_config",
          "sed -i \"s/.*PasswordAuthentication.*/PasswordAuthentication no/g\" /etc/ssh/sshd_config",
          "sed -i \"s/.*AllowTcpForwarding.*/AllowTcpForwarding yes/g\" /etc/ssh/sshd_config",
          "mkdir -p /root/.ssh",
          "echo \"${join("\n", var.ssh_public_keys)}\" > /root/.ssh/authorized_keys",
          "echo \"${join("\n", formatlist("command=\\\"/bin/tunnel\\\" %s", var.tunnel_only_ssh_public_keys))}\" >> /root/.ssh/authorized_keys",
          "echo \"Authorized keys:\"",
          "cat /root/.ssh/authorized_keys",
          "chmod 700 /root/.ssh",
          "chmod 600 /root/.ssh/authorized_keys",
          "echo \"root:root\" | chpasswd",
          "echo -n > /etc/motd",
          "echo \"#!/bin/bash\" > /bin/tunnel",
          "echo \"echo You can now establish a connection using ssh tunnel.\" >> /bin/tunnel",
          "echo \"echo Hit Ctrl+C to terminate.\" >> /bin/tunnel",
          "echo \"while true\" >> /bin/tunnel",
          "echo \"do\" >> /bin/tunnel",
          "echo \"  sleep 100\" >> /bin/tunnel",
          "echo \"done\" >> /bin/tunnel",
          "chmod +x /bin/tunnel",
          "/usr/sbin/sshd -D",
        ])
      ]
      logConfiguration : {
        logDriver : "awslogs"
        options : {
          awslogs-group : aws_cloudwatch_log_group.service.name
          awslogs-region : data.aws_region.current.name
          awslogs-stream-prefix : "app"
        }
      },
      }, var.efs_filesystem_id == "" ? {} : {
      mountPoints : [
        {
          sourceVolume : "efs"
          containerPath : "/mnt/efs"
        }
      ]
    })
  ])

  dynamic "volume" {
    for_each = var.efs_filesystem_id == "" ? [] : [""]
    content {
      name = "efs"
      efs_volume_configuration {
        file_system_id = var.efs_filesystem_id
        root_directory = "/"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
