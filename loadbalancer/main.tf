resource "aws_lb" "app_loadbalancer" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = "application"
  security_groups    = var.alb_sg
  subnets            = var.alb_subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "default" {
  name = "${var.alb_name}-target-group"
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

resource "aws_lb_listener" "http" {
  count = var.create_http_listener ? 1 : 0
  load_balancer_arn = "${aws_lb.app_loadbalancer.arn}"
  port = var.listener_port
  protocol = var.protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "You shall not pass"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.create_https_listener ? 1 : 0

  load_balancer_arn = "${aws_lb.app_loadbalancer.arn}"
  port = 443
  protocol = "HTTPS"
  certificate_arn = var.certificate
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "You shall not pass"
      status_code  = "503"
    }
  }
}
