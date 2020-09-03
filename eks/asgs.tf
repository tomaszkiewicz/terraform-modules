locals {
  medium_asg_launch_template = merge(var.override_ami_id != "" ? {
    ami_id = var.override_ami_id
  } : {}, {
    name                    = "medium"
    override_instance_types = ["t3.medium", "t2.medium", "t3a.medium"]
    asg_max_size            = var.medium_asg_max_size
    asg_min_size            = var.medium_asg_min_size
    asg_desired_capacity    = var.medium_asg_desired_capacity
    on_demand_base_capacity = var.medium_asg_on_demand_base_capacity
    bootstrap_extra_args    = "--use-max-pods false"
    #kubelet_extra_args      = "--node-labels=kubernetes.io/size=medium"

    tags = [
      {
        "key"                 = "k8s.io/cluster-autoscaler/enabled"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${var.tenant_name}-${var.cluster_name}"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/node-template/label/type"
        "propagate_at_launch" = "false"
        "value"               = "medium"
      },
    ]
  })

  large_asg_launch_template = merge(var.override_ami_id != "" ? {
    ami_id = var.override_ami_id
  } : {}, {
    name                    = "large"
    override_instance_types = ["t3.large", "t2.large", "t3a.large"]
    asg_max_size            = var.large_asg_max_size
    asg_min_size            = var.large_asg_min_size
    asg_desired_capacity    = var.large_asg_desired_capacity
    on_demand_base_capacity = var.large_asg_on_demand_base_capacity
    bootstrap_extra_args    = "--use-max-pods false"
    #kubelet_extra_args      = "--node-labels=kubernetes.io/size=large"

    tags = [
      {
        "key"                 = "k8s.io/cluster-autoscaler/enabled"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${var.tenant_name}-${var.cluster_name}"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/node-template/label/type"
        "propagate_at_launch" = "false"
        "value"               = "large"
      },
    ]
  })

  gitlab_ci_runner_medium_asg_launch_template = merge(var.override_ami_id != "" ? {
    ami_id = var.override_ami_id
  } : {}, {
    name                    = "gitlab-ci-runner-medium"
    override_instance_types = ["t3.medium", "t2.medium", "t3a.medium"]
    asg_max_size            = var.gitlab_ci_runner_medium_asg_max_size
    asg_min_size            = var.gitlab_ci_runner_medium_asg_min_size
    asg_desired_capacity    = var.gitlab_ci_runner_medium_asg_desired_capacity
    on_demand_base_capacity = var.gitlab_ci_runner_medium_asg_on_demand_base_capacity
    bootstrap_extra_args    = "--use-max-pods false"
    kubelet_extra_args      = "--register-with-taints workload-type=gitlab-ci-runner:NoSchedule --node-labels=workload-type=gitlab-ci-runner"

    tags = [
      {
        "key"                 = "Name"
        "propagate_at_launch" = "true"
        "value"               = "${var.cluster_name}-gitlab-ci-runner-medium"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/enabled"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${var.tenant_name}-${var.cluster_name}"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/node-template/label/workload-type"
        "propagate_at_launch" = "false"
        "value"               = "gitlab-ci-runner"
      },
    ]
  })

  worker_groups_launch_template = [for x in concat([
    var.medium_asg_enabled ? local.medium_asg_launch_template : null,
    var.large_asg_enabled ? local.large_asg_launch_template : null,
    var.gitlab_ci_runner_medium_asg_enabled ? local.gitlab_ci_runner_medium_asg_launch_template : null,
    ],
    var.additional_worker_groups_launch_templates
  ) : x if x != null]
}
