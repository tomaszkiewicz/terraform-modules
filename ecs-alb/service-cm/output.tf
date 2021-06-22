output "security_group_id" {
  value = module.sg.id
}

output "cloudmap_service_arn" {
  value = aws_service_discovery_service.service.arn
}
