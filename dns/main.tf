resource "aws_route53_zone" "main" {
  name = var.dns_zone

  lifecycle {
    prevent_destroy = true
  }
}
