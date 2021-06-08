output "alb_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_target_group" {
  value = aws_lb_target_group.default.arn
}
