variable "gitlab_registration_token" {}
variable "gitlab_runner_instance_type" { default = "c5.large" }
variable "max_spot_price" { default = "0.09" }
variable "gitlab_runner_tags" {
  type = list
  default = [
    "dedicated",
  ]
}

locals {
  script = <<EOF
echo "==> Check identity"
aws sts get-caller-identity

echo "==> Install docker"
apk add --update docker

echo "==> Install docker-machine"
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
chmod +x /usr/local/bin/docker-machine

echo "==> Symlink configs for docker-machine"
mkdir -p /data/docker
ln -s /data/docker /root/.docker

echo "==> Install gitlab-runner"
curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 > /usr/local/bin/gitlab-runner &&
chmod +x /usr/local/bin/gitlab-runner

echo "==> Generate template"
mkdir -p /data
cat << TEMPLATE > /data/template.toml
[[runners]]
  [runners.docker]
    image = "alpine"
    privileged = true
    disable_cache = true

  [runners.machine]
    IdleCount = 0
    IdleTime = 600
    MaxBuilds = 15
    MachineDriver = "amazonec2"
    MachineName = "gitlab-docker-machine-%s"
    MachineOptions = [
      "amazonec2-use-private-address=true",
      "amazonec2-tags=runner-manager-name,gitlab-aws-autoscaler,gitlab,true,gitlab-runner-autoscale,true",
      "amazonec2-request-spot-instance=true",
      "amazonec2-spot-price=${var.max_spot_price}",
#      "amazonec2-block-duration-minutes=60"
    ]
TEMPLATE

touch /data/token
if ! grep -q "$REGISTRATION_TOKEN" /data/token; then
  echo "==> Token changed, unregistering existing runner"
  gitlab-runner unregister --all-runners

  echo "==> Killing instances"
  docker-machine rm -f $(docker-machine ls -q)

  echo "==> Removing configuration"
  rm -fv /data/config.toml
fi

echo "==> Register the runner if needed"
if [ ! -f /data/config.toml ]; then
  echo "$REGISTRATION_TOKEN" > /data/token

  gitlab-runner register -n \
    --template-config /data/template.toml \
    --config /data/config.toml \
    --executor docker+machine \
    --docker-image pragmaticcoders/ws \
    --tag-list "${join(",", var.gitlab_runner_tags)}" \
    --run-untagged=true \
    --locked=false
fi

echo "==> Start runner"
gitlab-runner run -c /data/config.toml
EOF
}

resource "aws_ecs_service" "service" {
  name             = "gitlab-runner-manager"
  cluster          = module.ecs.cluster_id
  task_definition  = aws_ecs_task_definition.gitlab_runner_manager.arn
  desired_count    = 1
  platform_version = "1.4.0"

  network_configuration {
    assign_public_ip = true
    security_groups = [
      module.sg_gitlab_runner.id
    ]
    subnets = module.vpc.public_subnet_ids
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}

resource "aws_ecs_task_definition" "gitlab_runner_manager" {
  family             = "gitlab-runner-manager"
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  task_role_arn      = module.iam_role_gitlab_runner.arn
  execution_role_arn = module.ecs.execution_role_arn
  requires_compatibilities = [
    "FARGATE",
  ]

  container_definitions = jsonencode([
    {
      name : "app",
      image : "pragmaticcoders/ws",
      essential : true,
      user : "root",
      entryPoint : [
        "/bin/sh",
        "-c",
      ]
      command : [
        local.script,
      ]
      environment : [
        {
          name : "AWS_VPC_ID",
          value : module.vpc.id,
        },
        {
          name : "AWS_SUBNET_ID",
          value : module.vpc.public_subnet_ids[0],
        },
        {
          name : "AWS_SECURITY_GROUP",
          value : module.sg_gitlab_runner.name,
        },
        {
          name : "AWS_INSTANCE_TYPE",
          value : var.gitlab_runner_instance_type,
        },
        {
          name : "CI_SERVER_URL",
          value : "https://gitlab.com",
        },
        {
          name : "RUNNER_NAME",
          value : "gitlab-runner-aws-autoscaling",
        },
        {
          name : "REGISTRATION_TOKEN",
          value : var.gitlab_registration_token,
        },
        {
          name : "REGISTER_NON_INTERACTIVE",
          value : "true",
        },
      ],
      mountPoints : [
        {
          containerPath : "/data",
          sourceVolume : "data"
        }
      ],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : "/ecs/service/gitlab-runner-manager",
          awslogs-region : var.aws_region,
          awslogs-stream-prefix : "app"
        }
      },
    }
  ])

  volume {
    name = "data"

    efs_volume_configuration {
      file_system_id = module.efs.id
      root_directory = "/"
    }
  }
}

resource "aws_cloudwatch_log_group" "gitlab_runner_manager" {
  name              = "/ecs/service/gitlab-runner-manager"
  retention_in_days = 14
}
