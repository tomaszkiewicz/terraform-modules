module "efs" {
  source = "github.com/pragmaticcoders/terraform-modules/efs"

  subnet_ids = module.vpc.public_subnet_ids
  security_group_ids = [
    module.efs_sg.id,
  ]
  # notifications_sns_topic_arn =
}

module "efs_sg" {
  source = "github.com/pragmaticcoders/terraform-modules/sg"

  name   = "efs"
  vpc_id = module.vpc.id
  internal_ports = [
    2049,
  ]
  # source_sg_ports = [
  #   2049,
  # ]
  # source_sg_ids = [
  #   module.sg_gitlab_runner_manager.id,
  # ]
}
