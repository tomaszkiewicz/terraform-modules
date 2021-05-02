resource "aws_lb" "ecs" {
  name            = local.alb_name
  internal        = false
  ip_address_type = "ipv4"
  security_groups = [
    module.ecs_alb_sg.security_group_id,
  ]
  subnets = var.subnet_ids
}

module "ecs_alb_sg" {
  source = "../../sg"

  name   = "${local.alb_name}-alb"
  vpc_id = var.vpc_id
  ports = [
    80,
    443,
  ]
}

resource "aws_lb_target_group" "ecs_default" {
  name     = "${local.alb_name}-alb-default"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "ecs_http" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ecs_https" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.local.arn

  default_action {
    target_group_arn = aws_lb_target_group.ecs_default.arn
    type             = "forward"
  }
}
