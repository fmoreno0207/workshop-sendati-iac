# live/dev/iam-ssm/terragrunt.hcl
# Rol e instance profile para SSM. Va antes que ec2.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  component = "iam-ssm"

  nombre = "${local.env_vars.locals.name_prefix}-${local.env_vars.locals.environment}-ssm"

  tags = merge(
    local.env_vars.locals.tags_base,
    {
      Componente = local.component
    }
  )
}

terraform {
  source = "../../../modules/iam-ssm"
}

inputs = {
  nombre = local.nombre
  tags   = local.tags
}
