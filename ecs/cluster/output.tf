output "cluster_id" {
  value = module.ecs.this_ecs_cluster_id
}

output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.ecs.id
}