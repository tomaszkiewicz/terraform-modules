resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = "ecs.local"
  description = "ecs"
  vpc         = var.vpc_id
}
