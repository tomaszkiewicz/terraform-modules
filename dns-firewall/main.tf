resource "aws_route53_resolver_firewall_config" "config" {
  resource_id        = var.vpc_id
  firewall_fail_open = var.firewall_fail_open
}

resource "aws_route53_resolver_firewall_domain_list" "allow_domain_list" {
  name    = "${var.name}-allow-domain-list"
  domains = var.allowed_domains
  tags = {
    name = var.name
  }
}

resource "aws_route53_resolver_firewall_domain_list" "block_domain_list" {
  name    = "${var.name}-block-domain-list"
  domains = ["*"]
  tags = {
    name = var.name
  }
}

resource "aws_route53_resolver_firewall_rule_group" "rule_group" {
  name = "${var.name}-rule-group"
  tags = {
    name = var.name
  }
}

resource "aws_route53_resolver_firewall_rule" "allow-rule" {
  name                    = "${var.name}-allow-rule"
  action                  = "ALLOW"
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.allow_domain_list.id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.rule_group.id
  priority                = 100
}

resource "aws_route53_resolver_firewall_rule" "block-rule" {
  name                    = "${var.name}-block-rule"
  action                  = "BLOCK"
  block_response          = "NODATA"
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.block_domain_list.id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.rule_group.id
  priority                = 110
}

resource "aws_route53_resolver_firewall_rule_group_association" "example" {
  name                   = "${var.name}-association"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.rule_group.id
  priority               = 120
  vpc_id                 = var.vpc_id
}
