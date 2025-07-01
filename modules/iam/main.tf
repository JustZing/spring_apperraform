resource "aws_iam_role" "argo_service_account_role" {
  name = "${var.project_name}-argo-sa-role"

  assume_role_policy = data.aws_iam_policy_document.oidc_assume_policy.json
}

data "aws_iam_policy_document" "oidc_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_policy" "custom_policy" {
  name   = "${var.project_name}-argo-access"
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "argo_attach" {
  policy_arn = aws_iam_policy.custom_policy.arn
  role       = aws_iam_role.argo_service_account_role.name
}

