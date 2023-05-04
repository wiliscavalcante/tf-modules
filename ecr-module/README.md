# Módulo Terraform para criação de repositórios ECR

Este módulo do Terraform é utilizado para criar um repositório ECR (Amazon Elastic Container Registry) na AWS. Ele permite que você configure o nome do repositório, a mutabilidade das tags de imagem, a verificação de imagem ao fazer push e tags personalizadas. Além disso, o módulo também fornece a opção de criar uma política de ciclo de vida para o repositório.

## Uso

### Exemplo completo

```terraform
provider "aws" {
  region = local.region
}

locals {
  region = "sa-east-1"
}


module "ecr_repo" {
  source = "github.com/wiliscavalcante/tf-modules.git//ecr-module-new"

  name        = "meu-repo-privado"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
  enable_lifecycle_policy = true

  tags = {
    Environment = "Production"
    Team = "DevOps"
  }
}

output "repository_url" {
  value = module.ecr_repo.repository_url
}

output "registry_id" {
  value = module.ecr_repo.registry_id
}
```

## Recursos criados

- `aws_ecr_repository` - O repositório ECR em si.
- `aws_ecr_lifecycle_policy` - (Opcional) Uma política de ciclo de vida para o repositório.

## Variáveis

- `name` (obrigatório): O nome do repositório ECR.
- `image_tag_mutability` (opcional): A mutabilidade das tags de imagem. Valor padrão é `MUTABLE`.
- `scan_on_push` (opcional): Ativa a verificação de imagem ao fazer push. Valor padrão é `true`.
- `tags` (opcional): Tags personalizadas para o repositório. Valor padrão é `{}`.
- `enable_lifecycle_policy` (opcional): Ativa ou desativa a criação de uma política de ciclo de vida para o repositório ECR. Valor padrão é `false`.
- `days_to_keep` (opcional): O número de dias para manter as imagens no repositório. Valor padrão é `30`.

## Outputs

- `repository_url`: A URL do repositório ECR criado.
- `registry_id`: O ID do registro do repositório ECR criado.
