variable "region" {
  description = "Região da AWS"
  type        = string
}

variable "name" {
  description = "Nome do NLB"
  type        = string
}

variable "internal" {
  description = "Se o NLB é interno ou não"
  type        = bool
}

variable "subnet_ids" {
  description = "IDs das subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
}
variable "enable_cross_zone_load_balancing" {
  description = "Indica se o balanceamento de carga entre zonas está ativado"
  type        = bool
  default     = false
}
