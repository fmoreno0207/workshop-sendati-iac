# bootstrap/live/root.hcl
# Provider y state del bootstrap.

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Terragrunt 1.x usa OpenTofu por defecto.
terraform_binary              = "terraform"
terragrunt_version_constraint = ">= 1.1.6, < 2.0.0"

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.env_vars.locals.region}"
}

terraform {
  required_version = "1.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
EOF
}

# State del bootstrap en un bucket propio, que crea Terragrunt (terragrunt backend bootstrap).
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.env_vars.locals.bootstrap_state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.env_vars.locals.region
    encrypt        = true
    use_lockfile   = true
    s3_bucket_tags = local.env_vars.locals.tags_base
  }
}
