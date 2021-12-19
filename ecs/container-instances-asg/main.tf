resource "aws_launch_configuration" "ecs" {
  name_prefix          = "ecs-${lower(var.cluster_name)}-${lower(var.ami)}-"
  image_id             = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.create_instance_profile ? module.instance_profile[0].instance_profile_arn : var.instance_profile_arn

  security_groups = var.create_security_group ? [module.sg[0].id] : var.security_groups

  user_data = <<-EOF
    #!/bin/bash
    echo "==> Setting up ECS cluster..."
    echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config

    echo "==> Executing injected user data"
    ${var.user_data}

    echo "==> All done"
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  name                = aws_launch_configuration.ecs.name
  vpc_zone_identifier = var.subnet_ids

  launch_configuration = aws_launch_configuration.ecs.name

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  enabled_metrics = ["GroupTotalInstances"]

  lifecycle {
    ignore_changes = [
      desired_capacity,
    ]
    create_before_destroy = true
  }

  timeouts {
    delete = "40m"
  }

  # initial_lifecycle_hook {
  #   name                    = "ecs-draining"
  #   default_result          = "ABANDON"
  #   heartbeat_timeout       = 1500
  #   lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
  #   notification_target_arn = "${var.ecs_draining_sns_arn}"
  #   role_arn                = "${var.ecs_draining_sns_role_arn}"
  # }

  tag {
    key                 = "Name"
    value               = "ecs-${var.cluster_name}"
    propagate_at_launch = true
  }
}

# resource "aws_autoscaling_notification" "ecs" {
#   group_names = [
#     "${aws_autoscaling_group.ecs.name}",
#   ]

#   notifications = [
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#   ]

#   topic_arn = "${var.ecs_draining_sns_arn}"
# }
