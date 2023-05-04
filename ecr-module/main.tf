resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.enable_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep images for ${var.days_to_keep} days"
        selection    = {
          tagStatus    = "any"
          countType    = "sinceImagePushed"
          countNumber  = var.days_to_keep
          countUnit    = "days"
        }
        action       = {
          type = "expire"
        }
      }
    ]
  })
}
