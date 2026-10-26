# bootstrap/live/state-bucket/terragrunt.hcl
# Bucket del state de mi-project. Se corre a mano, una vez.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  component = "backend"

  tags = merge(
    local.env_vars.locals.tags_base,
    {
      Componente = local.component
    }
  )
}

terraform {
  source = "../../modules/state-bucket"
}

inputs = {
  nombre = local.env_vars.locals.state_bucket
  tags   = local.tags
}
