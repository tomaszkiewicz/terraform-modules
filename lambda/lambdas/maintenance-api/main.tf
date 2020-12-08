module "lambda" {
  source = "../.."

  name               = "edge-maintenance-api"
  source_dir         = "${path.module}/source"
  edge               = true
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

output "arn" {
  value = module.lambda.arn
}

output "version" {
  value = module.lambda.version
}
