# Módulo AWS KMS

Este módulo Terraform provisiona uma chave e um alias do KMS na conta da AWS.

## Variáveis

As seguintes variáveis podem ser definidas:

| Nome | Tipo | Padrão | Descrição |
|------|------|--------|-----------|
| `alias_name` | string | `"alias/my-kms-alias"` | O nome do alias a ser criado para a chave KMS. |
| `customer_master_key_spec` | string | `"SYMMETRIC_DEFAULT"` | Especifica se a chave contém uma chave simétrica ou um par de chaves assimétricas e os algoritmos de criptografia ou assinatura que a chave suporta. Valores válidos: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, ou `ECC_SECG_P256K1`. O padrão é `SYMMETRIC_DEFAULT`. |
| `deletion_window_in_days` | number | `30` | O período de carência em dias antes da remoção definitiva da chave KMS. |
| `description` | string | `"Example KMS Key"` | A descrição da chave KMS. |
| `enable_key_rotation` | bool | `true` | Especifica se a rotação de chave está habilitada. O valor padrão é `true`. |
| `key_usage` | string | `"ENCRYPT_DECRYPT"` | Especifica o uso pretendido da chave. Valores válidos: `ENCRYPT_DECRYPT` ou `SIGN_VERIFY`. O valor padrão é `ENCRYPT_DECRYPT`. |
| `multi_region` | bool | `false` | Indica se a chave KMS é uma chave multi-região (`true`) ou regional (`false`). O valor padrão é `false`. |
| `policy` | any | `null` | A política de acesso à chave KMS. |
| `tags` | map(string) | `{"Environment" = "Production"}` | As tags a serem adicionadas na chave KMS. |

## Recursos

O módulo cria os seguintes recursos:

| Nome | Tipo | Descrição |
|------|------|-----------|
| `aws_kms_key.this` | `aws_kms_key` | Uma chave KMS na conta da AWS. |
| `aws_kms_alias.this` | `aws_kms_alias` | Um alias para a chave KMS criada. |

O alias será criado no formato `alias/{alias_name}-{environment}`.

## Exemplo de Uso

```hcl
provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}

data "aws_caller_identity" "current" {}

module "kms_key" {
  source = "github.com/wiliscavalcante/tf-modules.git//kms-module"
  alias_name             = "my-kms-alias-01"
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
```
