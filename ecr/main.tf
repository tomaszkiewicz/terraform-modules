locals {
  repos = compact(concat(
    list(var.name),
    var.names,
  ))
}

resource "aws_ecr_repository" "repo" {
  for_each = toset(local.repos)

  name = each.value

  image_scanning_configuration {
    scan_on_push = var.scan_images
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_lifecycle_policy" "repo" {
  for_each = var.lifecycle_policy == "" ? [] : toset(local.repos)

  repository = aws_ecr_repository.repo[each.value].name
  policy     = var.lifecycle_policy
}

resource "aws_ecr_repository_policy" "repo" {
  for_each = var.repository_policy == "" ? [] : toset(local.repos)

  repository = aws_ecr_repository.repo[each.value].name
  policy     = var.repository_policy
}
