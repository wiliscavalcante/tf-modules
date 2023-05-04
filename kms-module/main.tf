data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description            = var.description
  deletion_window_in_days = var.deletion_window_in_days
  key_usage              = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation    = true
  tags                   = var.tags
  policy                 = var.policy

  alias {
    name = var.alias_name
  }
}

