resource "aws_ecr_repository" "repo" {
  name = var.name

  image_scanning_configuration {
    scan_on_push = var.scan_images
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_lifecycle_policy" "repo" {
  count = var.aws_ecr_lifecycle_policy == "" ? 0 : 1

  repository = aws_ecr_repository.repo.name
  policy     = var.aws_ecr_lifecycle_policy
}

resource "aws_ecr_repository_policy" "repo" {
  count = var.aws_ecr_repository_policy == "" ? 0 : 1

  repository = aws_ecr_repository.repo.name
  policy     = var.aws_ecr_repository_policy
}
