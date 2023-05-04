variable "name" {
  type        = string
  description = "Nome do repositório no ECR"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "Define a mutabilidade das tags no repositório"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Ativa a verificação de imagem no repositório"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags personalizadas para o repositório"
}
# variable "enable_lifecycle_policy" {
#   type        = bool
#   default     = false
#   description = "Ativa ou desativa a criação de um lifecycle policy para o repositório ECR"
# }
