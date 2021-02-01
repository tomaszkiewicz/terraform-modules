data "aws_route53_zone" "service_discovery" {
  count = var.service_discovery_namespace_type == "public" ? 1 : 0

  zone_id = join("", aws_service_discovery_public_dns_namespace.ecs.*.hosted_zone)
}
