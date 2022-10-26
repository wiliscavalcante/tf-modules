# output "fqdn" {
#   value       = module.s3_bucket.bucket_fqdn
#   description = "FQDN of bucket"
# }


output "id" {
  value       = module.s3_bucket.*.id
  description = "The ID of the s3 bucket."
}

output "bucket_arn" {
  value       = module.s3_bucket.*.bucket_arn
  description = "Bucket ARN"
}