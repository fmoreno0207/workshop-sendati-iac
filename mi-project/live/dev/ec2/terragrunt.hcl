# live/dev/ec2/terragrunt.hcl
# EC2 sin IP pública, con el instance profile de iam-ssm.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  component = "ec2"

  nombre = "${local.env_vars.locals.name_prefix}-${local.env_vars.locals.environment}-ec2"

  tags = merge(
    local.env_vars.locals.tags_base,
    {
      Componente = local.component
    }
  )
}

terraform {
  source = "../../../modules/ec2"
}

dependency "iam_ssm" {
  config_path = "../iam-ssm"

  # Para poder hacer plan antes de que exista iam-ssm. El pipeline no aplica planes con "mock-".
  mock_outputs = {
    instance_profile_name = "${local.env_vars.locals.name_prefix}-${local.env_vars.locals.environment}-ssm-profile"

  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show", "destroy"]
}

inputs = {
  nombre           = local.nombre
  instance_type    = local.env_vars.locals.instance_type
  instance_profile = dependency.iam_ssm.outputs.instance_profile_name
  tags             = local.tags
}
