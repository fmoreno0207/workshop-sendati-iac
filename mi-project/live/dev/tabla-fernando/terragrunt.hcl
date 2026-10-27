# live/dev/dynamodb/terragrunt.hcl
# Tabla NoSQL del entorno.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  component = "dynamodb"

  nombre = "${local.env_vars.locals.name_prefix}-${local.env_vars.locals.environment}-ferchu"

  tags = merge(
    local.env_vars.locals.tags_base,
    {
      Componente = local.component
      owner      = "fer"

    }
  )
}

terraform {
  source = "../../../modules/dynamodb"
}

inputs = {
  nombre = local.nombre
  tags   = local.tags
}
