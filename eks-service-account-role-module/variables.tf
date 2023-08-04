variable "service_account_name" {
  description = "Nome da Service Account do Kubernetes"
  type        = string
}

variable "arn_oidc_provider" {
  description = "ARN do provedor OIDC para o seu cluster EKS"
  type        = string
}

variable "audience" {
  description = "Valor da audiência para a condição do IAM policy"
  type        = string
  default     = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.eks_cluster_name}"
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "my-eks-cluster" # Substitua pelo nome do seu cluster EKS
}

variable "eks_namespace" {
  description = "Namespace da Service Account do Kubernetes"
  type        = string
  default     = "default" # Substitua pelo namespace da Service Account
}

variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-west-2" # Substitua pela região do seu cluster EKS
}
