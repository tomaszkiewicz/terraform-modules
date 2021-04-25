resource "aws_ssm_parameter" "subnet_ids" {
  name  = "/ecs/${var.cluster_id}/one-time-job/${var.name}/subnet-ids"
  type  = "String"
  value = tolist(var.subnet_ids)[0]
}

resource "aws_ssm_parameter" "security_groups" {
  name  = "/ecs/${var.cluster_id}/one-time-job/${var.name}/security-groups"
  type  = "String"
  value = module.sg.id
}
