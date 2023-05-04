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

  repository = aws_ecr_repository.this.name

  policy {
    rule {
      rule_priority = 1
      description   = "Remove untagged images older than 30 days"
      selection     = {
        tag_status = "untagged"
        created_at = "<= 30"
      }
      action {
        type = "expire"
      }
    }
  }
}
