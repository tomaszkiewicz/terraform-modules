resource "aws_lb_target_group" "ecs" {
  count = var.lb_listener_arn != "" ? 1 : 0

  name                 = "${var.cluster_id}-service-${var.name}"
  port                 = var.service_port
  vpc_id               = var.vpc_id
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 60

  dynamic "health_check" {
    for_each = var.health_check_path == "" ? [] : ["hack"]
    content {
      matcher           = "200-399"
      timeout           = 29
      interval          = 30
      healthy_threshold = 2
      path              = var.health_check_path
    }
  }
}

resource "random_integer" "priority" {
  min = 1
  max = 50000
  keepers = {
    listener_arn = var.lb_listener_arn
  }
}

resource "aws_lb_listener_certificate" "ecs" {
  count = var.lb_listener_arn != "" && var.lb_certificate_arn != "" ? 1 : 0

  listener_arn    = var.lb_listener_arn
  certificate_arn = var.lb_certificate_arn
}

resource "aws_lb_listener_rule" "ecs" {
  count = var.lb_listener_arn != "" ? 1 : 0

  listener_arn = var.lb_listener_arn
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = join("", aws_lb_target_group.ecs.*.arn)
  }

  condition {
    host_header {
      values = var.lb_hosts
    }
  }
}

resource "aws_lb_listener_rule" "ecs_www" {
  count = length(var.lb_hosts) > 0 && var.lb_enable_www_redirect ? 1 : 0

  listener_arn = var.lb_listener_arn
  priority     = random_integer.priority.result + 1

  action {
    type = "redirect"

    redirect {
      port        = "443"
      host        = var.lb_hosts[0]
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [
        "www.${var.lb_hosts[0]}"
      ]
    }
  }
}
