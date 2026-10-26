# Solo GitHub Actions, en los casos de var.sujetos, puede asumir el rol.
data "aws_iam_policy_document" "confianza" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.sujetos
    }
  }
}

# Políticas administradas de AWS, buscadas por nombre.
data "aws_iam_policy" "administradas" {
  for_each = toset(var.politicas)
  name     = each.value
}
