output "repository_url" {
  value       = this.private_repo.repository_url
  description = "URL do repositório no ECR"
}

output "registry_id" {
  value       = this.private_repo.registry_id
  description = "ID do registro no ECR"
}
