data "aws_iam_policy_document" "eks_service_account_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.arn_oidc_provider]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.audience}:sub"

      values = [
        "system:serviceaccount:${var.eks_namespace}:${var.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.audience}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "eks_service_account_role" {
  name               = "eks-${var.eks_cluster_name}-${var.service_account_name}-role"
  assume_role_policy = data.aws_iam_policy_document.eks_service_account_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_service_account_custom_policy_attachments" {
  count      = length(var.custom_policies)
  policy_arn = var.custom_policies[count.index]
  role       = aws_iam_role.eks_service_account_role.name
}
