resource "aws_security_group" "main" {
  name = var.name
  description = var.description == "" ? var.name : var.description
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

