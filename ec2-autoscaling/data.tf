# data "aws_kms_alias" "lookup" {
#   name = "alias/auto-scaling-encryption-${var.env}"
# }

# data "aws_kms_key" "existing_key" {
#   count   = length(data.aws_kms_alias.lookup.target_key_id) > 0 ? 1 : 0
#   key_id  = data.aws_kms_alias.lookup.target_key_id
# }
