# Módulo Terraform para criar um bucket S3 com criptografia do lado do servidor

Este módulo do Terraform cria um bucket S3 na AWS com criptografia do lado do servidor e outras opções de configuração.

## Uso

```hcl

provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}

module "s3_bucket_01" {
  source = "github.com/wiliscavalcante/tf-modules.git//s3-bucket-module"

  bucket_name = "bucket-terraform-01"
  force_destroy = true
  tags = {
    Name        = "my-bucket"
    Environment = "prod"
  }
}
```

## Recursos Criados

- `aws_s3_bucket`
- `aws_s3_bucket_server_side_encryption_configuration`
- `aws_s3_bucket_acl`
- `aws_s3_bucket_public_access_block`
- `aws_s3_bucket_request_payment_configuration`
- `aws_s3_bucket_versioning`

## Variáveis de Entrada

- `bucket_name` - (obrigatório) Nome do bucket S3
- `acl` - (opcional) ACL padrão a aplicar. Os valores válidos são `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, `bucket-owner-read` e `bucket-owner-full-control`. O padrão é `private`.
- `sse_algorithm` - (opcional) O algoritmo a ser usado para a criptografia do lado do servidor. Os valores válidos são `AES256` ou `aws:kms`. O padrão é `AES256`.
- `arn_kms` - (opcional) O ARN da chave do KMS a ser usada para a criptografia do lado do servidor.
- `key_enabled` - (opcional) Se a criptografia do lado do servidor está habilitada ou não. O padrão é `true`.
- `request_payer` - (opcional) Especifica quem deve arcar com o custo da transferência de dados do Amazon S3. Os valores válidos são `BucketOwner` ou `Requester`. O padrão é `BucketOwner`.
- `tags` - (opcional) Um mapeamento de tags para atribuir ao bucket.
- `versioning` - (opcional) Status de versionamento do bucket. Os valores válidos são `Disabled`, `Enabled` e `Suspended`. O padrão é `Disabled`.

## Outputs

- `id` - ID do bucket S3 criado.
- `bucket_arn` - ARN do bucket S3 criado.
