# bootstrap/live/env.hcl
# Nombres de los buckets. mi-project usa el mismo nombre para su state.
locals {
  name_prefix = "workshop"
  region      = get_env("AWS_REGION", "us-east-1")
  cuenta      = get_aws_account_id()

  # State del bootstrap (lo crea Terragrunt).
  bootstrap_state_bucket = "${local.name_prefix}-${local.cuenta}-${local.region}-bootstrap-tfstate"

  # State de mi-project (lo crea Terraform).
  state_bucket = "${local.name_prefix}-${local.cuenta}-${local.region}-tfstate"

  # Repo y entornos que usa el pipeline (OIDC).
  github_repo = "fmoreno0207/workshop-sendati-iac"
  entornos    = ["dev", "qa"]

  tags_base = {
    Proyecto  = local.name_prefix
    Entorno   = "bootstrap"
    ManagedBy = "terraform"
  }
}
