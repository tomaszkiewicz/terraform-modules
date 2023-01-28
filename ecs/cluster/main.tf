module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name                          = var.cluster_name

  fargate_capacity_providers = {
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }

  tags = {
    Name = var.cluster_name
  }
}
