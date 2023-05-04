resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.repository_name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  image_tag_mutability = var.image_tag_mutability

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy_enabled == true ? [1] : []
    content {
      policy_text = var.lifecycle_policy_text
    }
  }
}
