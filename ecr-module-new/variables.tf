variable "repository_name" {
  type        = string
  description = "O nome do repositório ECR"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Indica se as imagens devem ser escaneadas após serem enviadas para o repositório"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "Indica se as tags de imagem podem ser alteradas"
}

variable "lifecycle_policy_enabled" {
  type        = bool
  default     = false
  description = "Indica se uma política de ciclo de vida está habilitada para o repositório"
}

variable "lifecycle_policy_text" {
  type        = string
  default     = ""
  description = "O texto da política de ciclo de vida para o repositório"
}
