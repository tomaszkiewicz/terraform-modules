locals {
  provisioner_role_command = <<EOF
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

echo "Creating provisioner role for arn:${data.aws_partition.current.partition}:iam::$ACCOUNT_ID:root"

echo "==> Assuming role on master"

ROLE_ARN="arn:${data.aws_partition.current.partition}:iam::$MASTER_ACCOUNT_ID:role/ci-provisioner"
curl -s -o assume-role.sh https://gitlab.com/luktom/ci/-/raw/master/scripts/assume-role.sh && . assume-role.sh

echo "==> Assuming role on $SLAVE_ACCOUNT_NAME"

ROLE_ARN="arn:${data.aws_partition.current.partition}:iam::$SLAVE_ACCOUNT_ID:role/OrganizationAccountAccessRole"
curl -s -o assume-role.sh https://gitlab.com/luktom/ci/-/raw/master/scripts/assume-role.sh && . assume-role.sh

echo "==> Checking if provisioner role exists"

if ! aws iam get-role --role-name provisioner 2> /dev/null; then
  echo "==> Creating provisioner role"
  cat <<POLICY > /tmp/assume-role-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:${data.aws_partition.current.partition}:iam::$ACCOUNT_ID:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  aws iam create-role --role-name provisioner --assume-role-policy-document file:///tmp/assume-role-policy.json

  echo "==> Creating role policy"

  sleep 5

  aws iam attach-role-policy --role-name provisioner --policy-arn "arn:${data.aws_partition.current.partition}:iam::aws:policy/AdministratorAccess"
else
  echo "Role already exists"
fi

echo "==> All done"
EOF
}


resource "null_resource" "provisioner_role" {
  for_each = { for x in (var.create_provisioner_role ? var.accounts : []) : x.name => x if length(regexall(".*-master", x.name)) == 0 }

  triggers = {
    command = local.provisioner_role_command,
  }

  provisioner "local-exec" {
    interpreter = [
      "/bin/bash",
      "-c"
    ]
    environment = {
      MASTER_ACCOUNT_ID  = data.aws_caller_identity.identity.account_id
      SLAVE_ACCOUNT_ID   = aws_organizations_account.account[each.key].id
      SLAVE_ACCOUNT_NAME = each.key
    }
    command = local.provisioner_role_command
  }
}

data "aws_caller_identity" "identity" {}
