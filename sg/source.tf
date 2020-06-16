locals {
  source_sg_rules = {
    for x in setproduct(var.source_sg_ids, var.source_sg_ports) : join("-", flatten(x)) => {
      id : x[0],
      port : x[1],
    }
  }
  source_sg_rules_udp = {
    for x in setproduct(var.source_sg_ids, var.source_sg_udp_ports) : join("-", flatten(x)) => {
      id : x[0],
      port : x[1],
    }
  }
}

resource "aws_security_group_rule" "source_sg_ingress_tcp_ipv4" {
  for_each = local.source_sg_rules

  type      = "ingress"
  from_port = each.value.port
  to_port   = each.value.port
  protocol  = "tcp"

  source_security_group_id = each.value.id
  security_group_id        = aws_security_group.main.id
}

resource "aws_security_group_rule" "source_sg_ingress_udp_ipv4" {
  for_each = local.source_sg_rules_udp

  type      = "ingress"
  from_port = each.value
  to_port   = each.value
  protocol  = "udp"

  source_security_group_id = each.value.id
  security_group_id        = aws_security_group.main.id
}
