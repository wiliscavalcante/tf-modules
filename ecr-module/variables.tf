variable "create" {
  description = "Determina se os recursos serão criados (afeta todos os recursos)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Um mapa de tags para adicionar a todos os recursos"
  type        = map(string)
  default     = {}
}

variable "repository_type" {
  description = "O tipo de repositório a ser criado. Seja 'público' ou 'privado'"
  type        = string
  default     = "private"
}

################################################################################
# Repository
################################################################################

variable "create_repository" {
  description = "Determina se um repositório será criado"
  type        = bool
  default     = true
}

variable "repository_name" {
  description = "Nome do repositório"
  type        = string
  default     = ""
}

variable "repository_image_tag_mutability" {
  description = "A configuração de mutabilidade da tag para o repositório. Deve ser um dos seguintes: `MUTABLE` ou `IMMUTABLE`. O padrão é `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "repository_encryption_type" {
  description = "O tipo de criptografia para o repositório. Deve ser um dos seguintes: `KMS` ou `AES256`. O padrão é `AES256`"
  type        = string
  default     = null
}

variable "repository_kms_key" {
  description = "O ARN da chave KMS a ser usada quando o tipo de criptografia for `KMS`. Se não for especificado, usa a chave gerenciada padrão da AWS para ECR"
  type        = string
  default     = null
}

variable "repository_image_scan_on_push" {
  description = "Indica se as imagens são scaneadas após serem enviadas para o repositório (`true`) ou não scaneadas (`false`)"
  type        = bool
  default     = true
}

variable "repository_policy" {
  description = "A política JSON a ser aplicada ao repositório. Se não especificado, usa a política padrão"
  type        = string
  default     = null
}

variable "repository_force_delete" {
  description = "Se `true`, excluirá o repositório mesmo que contenha imagens. O padrão é `falso`"
  type        = bool
  default     = null
}

################################################################################
# Repository Policy
################################################################################

variable "attach_repository_policy" {
  description = "Determina se uma política de repositório será anexada ao repositório"
  type        = bool
  default     = true
}

variable "create_repository_policy" {
  description = "Determina se uma política de repositório será criada"
  type        = bool
  default     = true
}

variable "repository_read_access_arns" {
  description = "Os ARNs dos usuários/funções do IAM que têm acesso de leitura ao repositório"
  type        = list(string)
  default     = []
}

variable "repository_read_write_access_arns" {
  description = "Os ARNs dos usuários/funções do IAM que têm acesso de leitura/gravação ao repositório"
  type        = list(string)
  default     = []
}

################################################################################
# Lifecycle Policy
################################################################################

variable "create_lifecycle_policy" {
  description = "Determina se uma política de ciclo de vida será criada"
  type        = bool
  default     = true
}

variable "repository_lifecycle_policy" {
  description = "O documento de política. Esta é uma string formatada em JSON. Veja mais detalhes sobre [Parâmetros de política](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) nos documentos oficiais da AWS"
  type        = string
  default     = ""
}

################################################################################
# Public Repository
################################################################################

variable "public_repository_catalog_data" {
  description = "Configuração de dados do catálogo para o repositório"
  type        = any
  default     = {}
}

################################################################################
# Registry Policy
################################################################################

variable "create_registry_policy" {
  description = "Determina se uma política de registro será criada"
  type        = bool
  default     = false
}

variable "registry_policy" {
  description = "O documento de política. Esta é uma string formatada em JSON"
  type        = string
  default     = null
}

################################################################################
# Registry Pull Through Cache Rule
################################################################################

variable "registry_pull_through_cache_rules" {
  description = "Lista de regras de cache pull through para criar"
  type        = map(map(string))
  default     = {}
}

################################################################################
# Registry Scanning Configuration
################################################################################

variable "manage_registry_scanning_configuration" {
  description = "Determina se a configuração de verificação do registry será gerenciada"
  type        = bool
  default     = false
}

variable "registry_scan_type" {
  description = "o tipo de varredura a ser definido para o registro. Pode ser `ENHANCED` ou `BASIC`"
  type        = string
  default     = "ENHANCED"
}

variable "registry_scan_rules" {
  description = "Um ou vários blocos especificando regras de varredura para determinar quais filtros de repositório são usados ​​e com que frequência a varredura ocorrerá"
  type        = any
  default     = []
}

################################################################################
# Registry Replication Configuration
################################################################################

variable "create_registry_replication_configuration" {
  description = "Determina se uma configuração de replicação do registro será criada"
  type        = bool
  default     = false
}

variable "registry_replication_rules" {
  description = "As regras de replicação para uma configuração de replicação. São permitidos no máximo 10"
  type        = any
  default     = []
}