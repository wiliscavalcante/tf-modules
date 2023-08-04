module "eks_service_account_role" {
  source = "../eks-service-account-role-module" # Substitua pelo caminho correto para o diretório do módulo

  service_account_name = "my-service-account" # Substitua pelo nome da sua Service Account no Kubernetes
  arn_oidc_provider    = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/12345678901234567890abcde" # Substitua pelo ARN do provedor OIDC do seu cluster EKS
  eks_cluster_name     = "my-eks-cluster" # Substitua pelo nome do seu cluster EKS

  # Adicione as novas políticas ao atributo custom_policies
  custom_policies = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
  ]
}
