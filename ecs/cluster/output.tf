output "cluster_id" {
  value = module.ecs.this_ecs_cluster_id
}

output "id" {
  value = module.ecs.this_ecs_cluster_id
}

output "cluster_arn" {
  value = module.ecs.this_ecs_cluster_id
}

output "arn" {
  value = module.ecs.this_ecs_cluster_id
}

output "cluster_name" {
  value = var.cluster_name
}

output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.ecs.id
}

output "execution_role_arn" {
  value = module.iam_role_execution.arn
}

output "vpc_id" {
  value = var.vpc_id
}
