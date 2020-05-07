resource "aws_security_group_rule" "ingress_tcp_ipv4" {
  for_each = toset(var.ports)

  type        = "ingress"
  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ingress_tcp_ipv6" {
  for_each = var.enable_ipv6 ? toset(var.ports) : []

  type             = "ingress"
  from_port        = each.value
  to_port          = each.value
  protocol         = "tcp"
  ipv6_cidr_blocks = var.ipv6_cidr_blocks

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ingress_udp_ipv4" {
  for_each = toset(var.udp_ports)

  type        = "ingress"
  from_port   = each.value
  to_port     = each.value
  protocol    = "udp"
  cidr_blocks = var.cidr_blocks

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ingress_udp_ipv6" {
  for_each = var.enable_ipv6 ? toset(var.udp_ports) : []

  type             = "ingress"
  from_port        = each.value
  to_port          = each.value
  protocol         = "udp"
  ipv6_cidr_blocks = var.ipv6_cidr_blocks

  security_group_id = aws_security_group.main.id
}
