resource "aws_lb_target_group" "service-tg" {
  name = "${var.service-name}-target-group"
  port = var.service_port
  protocol = var.target_group_protocol
  vpc_id = "${var.vpc_id}"
  target_type = "ip"
  deregistration_delay = var.deregistration_delay
  health_check {
    healthy_threshold = var.healthy_threshold
    port = var.health_check_port
    interval = var.helth_check_interval
    path = var.health_check_path
    timeout = var.health_check_timeout
    unhealthy_threshold = var.unhealthy_threshold
    matcher = "200-399"
  }
}

resource "aws_lb_listener_rule" "service-rule" {
  listener_arn = var.listener
  priority     = var.priority

  action {
    type             = var.listener_action
    target_group_arn = aws_lb_target_group.service-tg.arn
  }
    condition {
    host_header {
      values = [var.host_header]
    }
  }
}


output "alb_target_group" {
  value = aws_lb_target_group.service-tg.arn
}