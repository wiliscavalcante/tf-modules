data "aws_iam_policy_document" "BUPolicyForEksServiceAccount" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["${var.arn_oidc_provider}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.audience}:sub"
      values = [
        "system:serviceaccount:namespace:serviceaccount-sa"
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

resource "aws_iam_role" "BURoleForEksServiceAccount" {
  name                 = "BURoleForEksServiceAccount"
  assume_role_policy   = data.aws_iam_policy_document.BUPolicyForEksServiceAccount.json
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
}
