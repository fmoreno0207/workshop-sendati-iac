# live/qa/env.hcl
# Valores del entorno. Es lo único que cambia entre dev y qa.
locals {
  name_prefix = "workshop"
  environment = "qa"
  region      = get_env("AWS_REGION", "us-east-1")

  instance_type = "t3.micro"

  tags_base = {
    Proyecto  = local.name_prefix
    Entorno   = local.environment
    ManagedBy = "terraform"
  }
}
