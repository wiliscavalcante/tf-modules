# outputs.tf

output "kms_key_id" {
  value = module.kms_key.key_id
}

output "kms_key_arn" {
  value = module.kms_key.arn
}

output "kms_key_alias" {
  value = module.kms_key.alias
}

output "kms_key_arn_alias" {
  value = module.kms_key.arn_alias
}

output "kms_key_description" {
  value = module.kms_key.description
}

output "kms_key_usage" {
  value = module.kms_key.key_usage
}

output "kms_customer_master_key_spec" {
  value = module.kms_key.customer_master_key_spec
}

output "kms_enable_key_rotation" {
  value = module.kms_key.enable_key_rotation
}

output "kms_multi_region" {
  value = module.kms_key.multi_region
}

output "kms_policy" {
  value = module.kms_key.policy
}
