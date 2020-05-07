resource "aws_security_group_rule" "egress_ipv4" {
  count = var.allow_egress ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress_ipv6" {
  count = var.allow_egress ? 1 : 0

  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = -1
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.main.id
}
