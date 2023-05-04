variable "repository_name" {
  description = "Nome do repositório"
  type        = string
}

variable "tags" {
  description = "Tags para o repositório"
  type        = map(string)
}

variable "image_tag_mutability" {
  description = "Política de mutabilidade de tags"
  type        = string
  default     = "MUTABLE"
}

variable "image_scanning_configuration" {
  description = "Configuração de varredura de imagens"
  type        = map(string)
  default     = null
}

variable "lifecycle_policy" {
  description = "Política de ciclo de vida"
  type        = map(string)
  default     = null
}
