resource "aws_cloudwatch_log_group" "kafka" {
  name              = "/msk/${var.name}"
  retention_in_days = var.logs_retention_days
}

resource "aws_msk_cluster" "kafka" {
  count = var.create ? 1 : 0

  cluster_name           = var.name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.cluster_size

  broker_node_group_info {
    instance_type   = var.instance_type
    ebs_volume_size = var.ebs_volume_size
    client_subnets  = slice(var.client_subnets, 0, var.cluster_size)
    security_groups = var.security_groups
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.monitoring_enabled
      }
      node_exporter {
        enabled_in_broker = var.monitoring_enabled
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.logs_enabled
        log_group = aws_cloudwatch_log_group.kafka.name
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  tags = {
    Name = var.name
  }

  lifecycle {
    ignore_changes = [
      configuration_info,
    ]
  }
}
