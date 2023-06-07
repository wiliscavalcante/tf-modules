variable "enable_cross_zone_load_balancing" {
  description = "Habilita o balanceamento de carga entre zonas"
  type        = bool
}

variable "listener_port" {
  description = "Porta para o listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocolo para o listener"
  type        = string
}

variable "name" {
  description = "Nome do NLB interno"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
}

variable "target_group_name" {
  description = "Nome do target group"
  type        = string
}

variable "target_group_port" {
  description = "Porta para o target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocolo para o target group"
  type        = string
}

variable "target_id" {
  description = "ID(s) do(s) target(s)"
  type        = list(string)
}

variable "target_type" {
  description = "Tipo de target"
  type        = string
  default     = "ip"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

