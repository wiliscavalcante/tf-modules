output "repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "URL do repositório no ECR"
}

output "registry_id" {
  value       = aws_ecr_repository.this.registry_id
  description = "ID do registro no ECR"
}
output "lifecycle_policy_id" {
  value       = aws_ecr_lifecycle_policy.this_lifecycle_policy.id
  description = "ID do lifecycle policy associado ao repositório ECR"
}
