module "default_pod_role" {
  source = "../role"

  name = "k8s-default-pod"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
}

module "node_reaper_role" {
  source = "../role"

  name = "k8s-node-reaper"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "autoscaling:DescribeAutoScalingGroups",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "cloudwatch_exporter_role" {
  source = "../role"

  name = "k8s-cloudwatch-exporter"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "grafana_pod_role" {
  source = "../role"

  name = "k8s-grafana"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:GetMetricData",
        "cloudwatch:ListMetrics"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "cert_manager_role" {
  source = "../role"

  name = "k8s-cert-manager"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:GetHostedZone",
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetChange"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "cluster_autoscaler_role" {
  source = "../role"

  name = "k8s-cluster-autoscaler"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "autoscaling:DescribeLaunchConfigurations"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTags",
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "external_dns_role" {
  source = "../role"

  name = "k8s-external-dns"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

module "k8s_alertmanager_cloudwatch_webhook" {
  source = "../role"

  name = "k8s-alertmanager-cloudwatch-webhook"
  trusted_aws_principals = [
    var.k8s_workers_iam_role_arn,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
