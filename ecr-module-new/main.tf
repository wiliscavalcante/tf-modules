resource "aws_ecr_repository" "ecr_repo" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  image_tag_mutability = var.image_tag_mutability

  # Adicionado bloco de política de ciclo de vida
  lifecycle_policy {
    ignore_existing_tags = true
    # Permite que a política de ciclo de vida seja opcional
    dynamic "policy" {
      for_each = var.lifecycle_policy_enabled ? [var.lifecycle_policy_text] : []
      content {
        policy_text = policy.value
      }
    }
  }
}
