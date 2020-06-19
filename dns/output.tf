output "dns_zone_nameservers" {
  value = aws_route53_zone.main.name_servers
}

output "nameservers" {
  value = aws_route53_zone.main.name_servers
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "id" {
  value = aws_route53_zone.main.id
}

output "zone_id" {
  value = aws_route53_zone.main.id
}

output "dns_zone" {
  value = var.dns_zone
}

output "domain_name" {
  value = var.dns_zone
}