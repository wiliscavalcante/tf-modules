resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}
resource "aws_ecr_lifecycle_policy" "this_lifecycle_policy" {
  count = var.enable_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.private_repo.name

  policy {
  rules = [
    {
      rule_priority = 1
      description   = "Expire images older than 30 days"
      selection     = {
        tag_status = "tagged"
        count_type = "sinceImagePushed"
        count_unit = "days"
        count_number = 30
      }
      action = {
        type = "expire"
      }
    }
  ]
}
}
