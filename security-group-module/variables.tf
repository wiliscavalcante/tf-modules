variable "security_group_name" {
  description = "Nome do Security Group"
  type        = string
}

variable "security_group_description" {
  description = "Descrição do Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "ingress_rules" {
  description = "Lista de regras de ingresso (entrada) no Security Group"
  type        = list(map(string))
  default     = []
}

variable "egress_rules" {
  description = "Lista de regras de egresso (saída) no Security Group"
  type        = list(map(string))
  default     = []
}
