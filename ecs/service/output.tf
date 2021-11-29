output "security_group_id" {
  value = var.enable_fargate ? module.sg[0].id : null
}

output "cloudmap_service_arn" {
  value = join("", aws_service_discovery_service.service.*.arn)
}
