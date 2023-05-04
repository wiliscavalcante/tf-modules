resource "aws_kms_key" "this" {
  description     = var.description
  policy          = var.policy
  deletion_window_in_days = var.deletion_window_in_days
  key_rotation_period = var.key_rotation_period
  customer_master_key_spec = var.customer_master_key_spec

  tags = var.tags
}
