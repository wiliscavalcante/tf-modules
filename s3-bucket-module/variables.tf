# variable "sse_algorithm" {
#   description = "The algorithm to use for server-side encryption"
#   type        = string
#   default     = "AES256"
#   validation {
#     condition     = can(regex("^(AES256|aws:kms)$", var.sse_algorithm))
#     error_message = "sse_algorithm must be either 'AES256' or 'aws:kms'"
#   }
# }
# variable "arn_kms" {
#   type = string
#   default = ""
# }
# variable "key_enabled" {
#   type = bool
#   default = true
# }

# variable "bucket_name" {
#   description = "Name of the bucket"
#   type        = string
# }

# variable "force_destroy" {
#   description = "Allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled."
#   type        = bool
#   default     = false
# }

# variable "acl" {
#   description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control. Defaults to private."
#   type        = string
#   default     = "private"
# }

# variable "versioning" {
#   description = "Status: Disabled, Enabled and Suspended"
#   type        = string
#   default     = "Disabled"
# }

# variable "tags" {
#   description = "(Optional) A mapping of tags to assign to the bucket."
#   type        = map(string)
#   default     = {}
# }

# variable "request_payer" {
#   description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. See Requester Pays Buckets developer guide for more information."
#   type        = string
#   default     = "BucketOwner"
# }

variable "acl" {
  description = "O ACL padronizado a aplicar. Os valores válidos são `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, `bucket-owner-read` e `bucket-owner-full-control`. O padrão é `private`."
  type        = string
  default     = "private"
}

variable "arn_kms" {
  description = "O ARN da chave do KMS a ser usada para a criptografia do lado do servidor"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Nome do bucket"
  type        = string
}

variable "force_destroy" {
  description = "Permitir a exclusão do objeto removendo qualquer bloqueio legal em qualquer versão do objeto. O padrão é falso. Esse valor deve ser definido como verdadeiro somente se o bucket tiver S3 object lock ativado."
  type        = bool
  default     = false
}

variable "key_enabled" {
  description = "Se a criptografia do lado do servidor está habilitada ou não. O padrão é true."
  type        = bool
  default     = true
}

variable "request_payer" {
  description = "Especifica quem deve arcar com o custo da transferência de dados do Amazon S3. Pode ser 'BucketOwner' ou 'Requester'. Consulte o guia do desenvolvedor 'Requester Pays Buckets' para obter mais informações."
  type        = string
  default     = "BucketOwner"
}

variable "sse_algorithm" {
  description = "O algoritmo a ser usado para a criptografia do lado do servidor"
  type        = string
  default     = "AES256"
  validation {
    condition     = can(regex("^(AES256|aws:kms)$", var.sse_algorithm))
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'"
  }
}

variable "tags" {
  description = "(Opcional) Um mapeamento de tags para atribuir ao bucket."
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Status: Desativado, Ativado e Suspenso"
  type        = string
  default     = "Disabled"
}
