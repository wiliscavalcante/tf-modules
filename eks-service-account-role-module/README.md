
```markdown
# Módulo Terraform: eks-service-account-role-module

Este módulo Terraform cria uma IAM Role para uma conta de serviço associada a uma Service Account no Amazon Elastic Kubernetes Service (EKS). O módulo permite personalizar a role e anexar políticas customizadas para controle de acesso.

## Uso

```hcl
module "eks_service_account_role" {
  source = "caminho/para/o/modulo/eks-service-account-role-module"

  service_account_name = "my-service-account" # Substitua pelo nome da sua Service Account no Kubernetes
  arn_oidc_provider    = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/12345678901234567890abcde" # Substitua pelo ARN do provedor OIDC do seu cluster EKS
  eks_cluster_name     = "my-eks-cluster" # Substitua pelo nome do seu cluster EKS

  # Adicione as novas políticas ao atributo custom_policies
  custom_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
  ]
}
```

## Variáveis

As seguintes variáveis podem ser configuradas:

- `service_account_name` (obrigatória): O nome da Service Account do Kubernetes.
- `arn_oidc_provider` (obrigatória): O ARN do provedor OIDC para o seu cluster EKS.
- `audience` (opcional): O valor da audiência para a condição do IAM policy. Valor padrão: `https://oidc.eks.us-west-2.amazonaws.com/id/my-eks-cluster`.
- `eks_cluster_name` (opcional): O nome do cluster EKS. Valor padrão: `my-eks-cluster`.
- `eks_namespace` (opcional): O namespace da Service Account do Kubernetes. Valor padrão: `default`.
- `aws_region` (opcional): A região da AWS. Valor padrão: `us-west-2`.

## Políticas Customizadas

Você pode anexar políticas customizadas adicionando os ARNs das políticas desejadas à variável `custom_policies`. Por exemplo, para adicionar a política "AmazonS3FullAccess" e "AmazonSQSFullAccess":

```hcl
module "eks_service_account_role" {
  source = "caminho/para/o/modulo/eks-service-account-role-module"

  # Outras variáveis...

  custom_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
  ]
}
```

```

Lembre-se de substituir as informações entre colchetes (`[]`) pelos valores corretos para o seu ambiente. Com esse README.md, você terá um guia claro para utilizar o módulo `eks-service-account-role-module` com facilidade.
