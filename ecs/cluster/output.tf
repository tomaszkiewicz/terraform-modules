output "cluster_id" {
  value = module.ecs.ecs_cluster_id
}

output "id" {
  value = module.ecs.ecs_cluster_id
}

output "cluster_arn" {
  value = module.ecs.ecs_cluster_id
}

output "arn" {
  value = module.ecs.ecs_cluster_id
}

output "cluster_name" {
  value = var.cluster_name
}

output "namespace_id" {
  value = join("", aws_service_discovery_public_dns_namespace.ecs.*.id, aws_service_discovery_private_dns_namespace.ecs.*.id)
}

output "namespace_hosted_zone_id" {
  value = join("", aws_service_discovery_public_dns_namespace.ecs.*.hosted_zone)
}

output "namespace_nameservers" {
  value = flatten(data.aws_route53_zone.service_discovery.*.name_servers)
}

output "service_discovery_domain" {
  value = var.service_discovery_domain
}

output "execution_role_arn" {
  value = module.iam_role_execution.arn
}

output "vpc_id" {
  value = var.vpc_id
}
