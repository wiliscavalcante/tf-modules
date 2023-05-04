variable "repository_name" {
  description = "O nome do repositório do ECR."
  type        = string
}

variable "scan_on_push" {
  description = "Habilita ou desabilita a verificação de imagem na submissão."
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "O tipo de mutabilidade das tags de imagem."
  type        = string
  default     = "MUTABLE"
}

variable "lifecycle_policy_text" {
  description = "O texto da política de ciclo de vida do ECR."
  type        = string
  default     = null
}

variable "lifecycle_policy_enabled" {
  description = "Habilita ou desabilita a política de ciclo de vida."
  type        = bool
  default     = false
}
