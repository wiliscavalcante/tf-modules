variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."  
  type        = map(any)
  default = {
    environment = "prod"
    terraform   = "true"
  }
}
