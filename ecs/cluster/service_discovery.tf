resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name = var.service_discovery_domain == "" ? "${var.cluster_name}.ecs.local" : var.service_discovery_domain
  vpc  = var.vpc_id
}
