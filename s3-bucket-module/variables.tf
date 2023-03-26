variable "server_side_encryption" {
  description = "The type of server-side encryption to use for the bucket."
  type        = string
  default     = "AES256"
  validation {
    condition = can(regex("^(AES256|aws:kms)$", var.server_side_encryption))
    error_message = "Server-side encryption must be 'AES256' or 'aws:kms'."
  }
}

variable "enable_encryption" {
  description = "Specifies whether to enable server-side encryption for the bucket."
  type        = bool
  default     = true
}
variable "kms_master_key_id" {
  description = "The ID of the KMS master key to use for server-side encryption."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled."
  type        = bool
  default     = false
}

variable "acl" {
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control. Defaults to private."
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "Status: Disabled, Enabled and Suspended"
  type        = string
  default     = "Disabled"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "request_payer" {
  description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. See Requester Pays Buckets developer guide for more information."
  type        = string
  default     = "BucketOwner"
}
