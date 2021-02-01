resource "aws_service_discovery_private_dns_namespace" "ecs" {
  count = var.service_discovery_namespace_type == "private" ? 1 : 0

  name = var.service_discovery_domain == "" ? "${var.cluster_name}.ecs.local" : var.service_discovery_domain
  vpc  = var.vpc_id
}

resource "aws_service_discovery_public_dns_namespace" "ecs" {
  count = var.service_discovery_namespace_type == "public" ? 1 : 0

  name = var.service_discovery_domain
}
