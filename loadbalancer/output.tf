output "alb_listener_http_arn" {
  value = aws_lb_listener.http.arn
}
output "alb_listener_https_arn" {
  value = aws_lb_listener.https[0].arn
}

output "alb_target_group" {
  value = aws_lb_target_group.default.arn
}

output "alb_dns_name" {
  value = aws_lb.app_loadbalancer.dns_name
}