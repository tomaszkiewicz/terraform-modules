module "sg_gitlab_runner" {
  source = "../sg"

  name = "gitlab-runner"
  vpc_id = module.vpc.id
  source_sg_ids = [
    module.sg_gitlab_runner_manager.id,
  ]
  source_sg_ports = [
    22,
    2376,
    3376,
  ]
}

module "sg_gitlab_runner_manager" {
  source = "../sg"

  name = "gitlab-runner-manager"
  vpc_id = module.vpc.id
}
