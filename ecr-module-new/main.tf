resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  image_tag_mutability = var.image_tag_mutability

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy != null ? [1] : []
    content {
      rules = jsonencode(var.lifecycle_policy)
    }
  }
}
