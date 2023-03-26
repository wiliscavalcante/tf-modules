variable "server_side_encryption_configuration" {
  description = "The server-side encryption configuration for the bucket."
  type = list(object({
    rule = list(object({
      apply_server_side_encryption_by_default = list(object({
        sse_algorithm = string
        kms_master_key_id = string
      }))
    }))
  }))
  default = [
    {
      rule = [
        {
          apply_server_side_encryption_by_default = [
            {
              sse_algorithm = "AES256"
              kms_master_key_id = ""
            }
          ]
        }
      ]
    }
  ]
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
