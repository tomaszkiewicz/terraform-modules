output "lb_listener_arn" {
  value = aws_lb_listener.ecs_https.arn
}

output "lb_dns_name" {
  value = aws_lb.ecs.dns_name
}

output "lb_zone_id" {
  value = aws_lb.ecs.zone_id
}
