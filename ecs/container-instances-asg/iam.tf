module "instance_profile" {
  source = "../../iam/role"
  count  = var.create_instance_profile ? 1 : 0

  name = "ecs-${var.cluster_name}"
  trusted_aws_services = [
    "ec2.amazonaws.com",
  ]
  attach_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
  ]
  create_instance_profile = true
}
