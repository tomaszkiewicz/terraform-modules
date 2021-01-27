module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = var.cluster_name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
  ]

  tags = {
    Name = var.cluster_name
  }
}
