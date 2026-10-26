# bootstrap/live/github-role-plan/terragrunt.hcl
# Rol de solo lectura para los plan del pipeline (PR y main).
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  bucket = local.env.state_bucket
  tags   = merge(local.env.tags_base, { Componente = "github-plan" })
}

terraform {
  source = "../../modules/github-role"
}

dependency "oidc" {
  config_path = "../github-oidc"

  # Solo para planear antes de que exista el proveedor.
  mock_outputs                            = { arn = "arn:aws:iam::mock:oidc-provider/token.actions.githubusercontent.com" }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show", "destroy"]
}

inputs = {
  nombre            = "${local.env.name_prefix}-github-plan"
  oidc_provider_arn = dependency.oidc.outputs.arn

  sujetos = [
    "${local.env.github_sub}:pull_request",
    "${local.env.github_sub}:ref:refs/heads/main",
  ]

  politicas = ["ReadOnlyAccess"]

  # Además de leer: crear y borrar el lock del state (use_lockfile).
  politica = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "LockDelState"
      Effect   = "Allow"
      Action   = ["s3:PutObject", "s3:DeleteObject"]
      Resource = "arn:aws:s3:::${local.bucket}/*.tflock"
    }]
  })

  tags = local.tags
}
