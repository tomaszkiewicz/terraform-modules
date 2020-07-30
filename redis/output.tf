output "dns_name" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}
