variable "policy_name" {
  description = "Nome da política IAM"
  type        = string
}

variable "policy_description" {
  description = "Descrição da política IAM"
  type        = string
}

variable "policy_document" {
  description = "Documento de política IAM no formato JSON"
  type        = string
}
