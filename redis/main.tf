data "aws_availability_zones" "azs" {}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = var.name
  replication_group_description = var.description
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_size
  port                          = var.port
  availability_zones            = slice(data.aws_availability_zones.azs.names, 0, var.cluster_size)
  automatic_failover_enabled    = var.auto_failover
  subnet_group_name             = aws_elasticache_subnet_group.redis.name
  security_group_ids            = var.security_group_ids
  engine_version                = var.engine_version
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  notification_topic_arn        = var.notifications_sns_topic_arn
}

resource "aws_elasticache_subnet_group" "redis" {
  name        = var.name
  description = var.description
  subnet_ids  = var.subnet_ids
}

resource "aws_route53_record" "redis" {
  count = var.dns_zone_id != "" && var.dns_name != "" ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "CNAME"
  ttl     = 300

  records = [
    aws_elasticache_replication_group.redis.primary_endpoint_address,
  ]

  lifecycle {
    prevent_destroy = true
  }
}
