resource "aws_kms_key" "this" {
  description            = var.description
  deletion_window_in_days = var.deletion_window_in_days
  key_usage              = var.key_usage
  customer_master_key_spec           = var.customer_master_key_spec
  enable_key_rotation    = var.enable_key_rotation
  tags                   = var.tags
  policy = jsonencode(var.policy)
}
# Cria um alias para a chave KMS, se houver um nome especificado
resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.key_id
}
