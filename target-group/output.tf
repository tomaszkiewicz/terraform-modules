output "alb_target_group" {
  value = aws_lb_target_group.service-tg.arn
}