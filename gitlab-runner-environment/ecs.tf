module "ecs" {
  source = "../ecs/cluster"

  cluster_name = "gitlab-runner"
  vpc_id       = module.vpc.id
}
