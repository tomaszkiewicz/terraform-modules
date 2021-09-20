output "alb_listener_http_arn" {
  value = var.create_http_listener ? aws_lb_listener.http[0].arn : null
}
output "alb_listener_https_arn" {
  value = var.create_https_listener ? aws_lb_listener.https[0].arn : null
}
output "alb_target_group" {
  value = aws_lb_target_group.default.arn
}

output "alb_dns_name" {
  value = aws_lb.app_loadbalancer.dns_name
}
