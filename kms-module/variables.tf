variable "deletion_window_in_days" {
  type        = number
  default     = 30
  description = "O período de carência em dias antes da remoção definitiva da chave KMS."
}

variable "tags" {
  type        = map(string)
  default     = {
    Environment = "Production"
  }
  description = "As tags a serem adicionadas na chave KMS."
}

variable "policy" {
  type        = any
  description = "A política de acesso à chave KMS."
}

variable "alias_name" {
  type        = string
  default     = ""
  description = "O nome do alias a ser criado para a chave KMS."
}

variable "description" {
  type        = string
  default     = "Example KMS Key"
  description = "A descrição da chave KMS."
}
