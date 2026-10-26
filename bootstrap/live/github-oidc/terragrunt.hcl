# bootstrap/live/github-oidc/terragrunt.hcl
# Proveedor OIDC para que GitHub Actions entre a AWS sin claves.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  component = "github-oidc"

  tags = merge(
    local.env_vars.locals.tags_base,
    {
      Componente = local.component
    }
  )
}

terraform {
  source = "../../modules/github-oidc"
}

inputs = {
  tags = local.tags
}
