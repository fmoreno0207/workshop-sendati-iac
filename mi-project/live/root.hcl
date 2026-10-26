# live/root.hcl
# Provider y backend comunes a todas las unidades.

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region   = local.env_vars.locals.region

  # Mismo nombre que crea el repo bootstrap.
  state_bucket = "${local.env_vars.locals.name_prefix}-${get_aws_account_id()}-${local.region}-tfstate"
}

# Terragrunt 1.x usa OpenTofu por defecto.
terraform_binary              = "terraform"
terragrunt_version_constraint = ">= 1.1.6, < 2.0.0"

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
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

# Backend S3 con lock nativo (sin DynamoDB). Terragrunt no toca el bucket.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket       = "${local.state_bucket}"
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = "${local.region}"
    encrypt      = true
    use_lockfile = true
  }
}
EOF
}
