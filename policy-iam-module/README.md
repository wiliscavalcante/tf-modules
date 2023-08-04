# Módulo Terraform: iam-policy-module

Este módulo Terraform cria uma política IAM no AWS Identity and Access Management (IAM). A política permite que você defina permissões granulares para recursos da AWS para usuários, grupos ou funções.

## Uso

```hcl
module "iam_policy" {
  source = "caminho/para/o/modulo/iam-policy-module"

  policy_name        = "MinhaPoliticaIAM"
  policy_description = "Política IAM para acesso a recursos específicos"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ]
        Resource = [
          "arn:aws:s3:::my-bucket/*",
          "arn:aws:s3:::my-bucket",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
        ]
        Resource = "*"
      },
    ]
  })
}
