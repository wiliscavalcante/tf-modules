# output "bucket_fqdn" {
#   value       = aws_s3_bucket.this.bucket_domain_name
#   description = "FQDN of bucket"
# }

output "id" {
  value       = join("", aws_s3_bucket.this.*.id)
  description = "The ID of the s3 bucket."
}

output "bucket_arn" {
  # value       = aws_s3_bucket.this.*.arn
  value       = join("", aws_s3_bucket.this.*.arn)
  description = "ARN of bucket"
}