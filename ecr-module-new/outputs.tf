output "repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "URL do repositório no ECR"
}

output "registry_id" {
  value       = aws_ecr_repository.this.registry_id
  description = "ID do registro no ECR"
}
