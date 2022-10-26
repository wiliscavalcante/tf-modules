variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."  
  type        = map(any)
  default = {
    environment = "prod"
    terraform   = "true"
  }
}


variable "s3_bucket_names" {
  description = "Nomes dos buckets"  
  type    = list(any)
  default = ["cavalcantech-tf01", "cavalcantech-tf02", "cavalcantech-tf03"]
}