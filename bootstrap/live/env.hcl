# bootstrap/live/env.hcl
# Nombres de los buckets. mi-project usa el mismo nombre para su state.
locals {
  name_prefix = "workshop"
  region      = get_env("AWS_REGION", "us-east-1")

  # Los nombres de bucket son únicos en todo S3: si alguno está tomado, cambiarlo acá.
  bootstrap_state_bucket = "${local.name_prefix}-bootstrap-tfstate" # lo crea Terragrunt
  state_bucket           = "${local.name_prefix}-sendati-tfstate"   # lo crea Terraform (state de mi-project)

  # Repo que usa el pipeline (OIDC), en formato inmutable de GitHub: dueño@id/repo@id.
  # Se ve con: gh api repos/fmoreno0207/workshop-sendati-iac/actions/oidc/customization/sub
  github_sub = "repo:fmoreno0207@148494548/workshop-sendati-iac@1434444862"
  entornos   = ["dev", "qa"]

  tags_base = {
    Proyecto  = local.name_prefix
    Entorno   = "bootstrap"
    ManagedBy = "terraform"
  }
}
