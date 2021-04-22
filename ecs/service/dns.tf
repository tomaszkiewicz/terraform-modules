resource "aws_route53_record" "alb" {
  for_each = var.dns_zone_id == "" ? [] : toset(var.lb_hosts)

  zone_id         = var.dns_zone_id
  name            = each.value
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}
