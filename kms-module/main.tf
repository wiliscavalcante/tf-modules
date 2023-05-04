resource "aws_kms_key" "this" {
  customer_master_key_spec = var.customer_master_key_spec
  deletion_window_in_days = var.deletion_window_in_days
  description            = var.description
  enable_key_rotation    = var.enable_key_rotation
  key_usage              = var.key_usage
  multi_region           = var.multi_region
  policy                 = jsonencode(var.policy)
  tags                   = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias_name}-${var.environment}"
  target_key_id = aws_kms_key.this.key_id
}

