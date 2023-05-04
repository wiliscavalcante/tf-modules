resource "aws_ecr_repository" "my_repo" {
  name = var.repository_name

  image_scanning_configuration = var.image_scanning_configuration
  image_tag_mutability         = var.image_tag_mutability
  lifecycle_policy             = var.lifecycle_policy ?? ""

  tags = merge({
    "Name" = var.repository_name
  }, var.repository_tags)
}

output "repository_url" {
  value = aws_ecr_repository.my_repo.repository_url
}
