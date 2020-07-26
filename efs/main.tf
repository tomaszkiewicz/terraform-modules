resource "aws_efs_file_system" "main" {
  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "efs" {
  count = var.dns_zone_id != "" ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "CNAME"
  ttl     = 60

  records = [aws_efs_file_system.main.dns_name]
}

resource "aws_efs_mount_target" "main" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = each.value
  security_groups = var.security_group_ids
}
