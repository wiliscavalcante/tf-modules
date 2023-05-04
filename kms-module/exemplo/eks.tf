provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}

data "aws_caller_identity" "current" {}

module "kms_key" {
  source = "github.com/wiliscavalcante/tf-modules.git//kms-module"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days = 10
  description            = "Example KMS Key"
  enable_key_rotation    = true
  environment            = "prd"
  key_usage              = "ENCRYPT_DECRYPT"
  multi_region           = false
  tags = {
    Environment = "Production"
    Terraform       = "true"
  }
  policy                = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:*",
        ]
        Resource = "*"
      }
    ]
  }
}
