# data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description            = var.description
  deletion_window_in_days = var.deletion_window_in_days
  key_usage              = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation    = true
  tags                   = var.tags
  policy = jsonencode(var.policy)
}
# Cria um alias para a chave KMS, se houver um nome especificado
resource "aws_kms_alias" "this_kms_alias" {
  name = var.alias_name
  target_key_id = aws_kms_key.this.key_id
}
