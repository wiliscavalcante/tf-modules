variable "name" {
  type        = string
  description = "O nome do repositório ECR."
}

variable "scan_on_push" {
  type        = bool
  description = "Indica se o escaneamento de imagens será ativado ao realizar um push para o repositório."
}

variable "image_tag_mutability" {
  type        = string
  description = "Indica se as tags de imagens serão mutáveis ou imutáveis."
}

variable "lifecycle_policy" {
  type        = list(object({
    rulePriority = number
    description  = string
    selection    = map(string)
    action       = map(string)
  }))
  description = "A política de ciclo de vida a ser aplicada ao repositório ECR."
}
