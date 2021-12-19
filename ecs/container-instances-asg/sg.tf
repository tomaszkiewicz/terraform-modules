module "sg" {
  source = "../../sg"
  count  = var.create_security_group ? 1 : 0

  name   = "ecs-${var.cluster_name}"
  vpc_id = var.vpc_id

  ports = var.ports
}
