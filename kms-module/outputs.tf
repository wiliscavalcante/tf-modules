output "key_id" {
  value = aws_kms_key.this.key_id
}

output "key_arn" {
  value = aws_kms_key.this.arn
}

output "key_alias" {
  value = aws_kms_alias.this.name
}

output "key_rotation_enabled" {
  value = aws_kms_key.this.enable_key_rotation
}

output "key_multi_region" {
  value = aws_kms_key.this.multi_region
}

output "key_policy" {
  value = aws_kms_key.this.policy
}
