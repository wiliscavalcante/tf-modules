resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}
if var.enable_lifecycle_policy {
  resource "aws_ecr_lifecycle_policy" "private_repo_lifecycle_policy" {
    repository = aws_ecr_repository.private_repo.name

    policy = jsonencode({
      rules = [
        {
          rulePriority      = 1
          description       = "Expire images older than 7 days"
          selection         = {
            tagStatus = "any"
            countType = "sinceImagePushed"
            countUnit = "days"
            countNumber = 7
          }
          action = {
            type = "expire"
          }
        }
      ]
    })
  }
}
