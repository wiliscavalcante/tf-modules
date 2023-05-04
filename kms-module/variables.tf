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
  default     = "alias/my-kms-alias"
  description = "O nome do alias a ser criado para a chave KMS."
}

variable "description" {
  type        = string
  default     = "Example KMS Key"
  description = "A descrição da chave KMS."
}
variable "key_usage" {
  description = "Especifica o uso pretendido da chave. Valores válidos: `ENCRYPT_DECRYPT` ou `SIGN_VERIFY`. O valor padrão é `ENCRYPT_DECRYPT`."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}
variable "customer_master_key_spec" {
  description = "Especifica se a chave contém uma chave simétrica ou um par de chaves assimétricas e os algoritmos de criptografia ou assinatura que a chave suporta. Valores válidos: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, ou `ECC_SECG_P256K1`. O padrão é `SYMMETRIC_DEFAULT`"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}
variable "enable_key_rotation" {
  description = "Sespecifica se a rotação de chave está habilitada. O valor padrão é true."
  type        = bool
  default     = true
}
variable "multi_region" {
  description = "Indica se a chave KMS é uma chave multi-região (`true`) ou regional (`false`). O valor padrão é `false`"
  type        = bool
  default     = false
}
