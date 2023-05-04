variable "repository_name" {
  type        = string
  description = "Nome do repositório ECR"
}

variable "repository_tags" {
  type        = map(string)
  default     = {}
  description = "Um mapa de tags para adicionar ao repositório ECR"
}

variable "image_scanning_configuration" {
  type        = map(string)
  default     = {}
  description = "As configurações de verificação de imagem para o repositório ECR"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "A mutabilidade das tags de imagem no repositório ECR"
}

variable "lifecycle_policy" {
  type        = optional(string)
  default     = null
  description = "A política de ciclo de vida a ser aplicada ao repositório ECR"
}
