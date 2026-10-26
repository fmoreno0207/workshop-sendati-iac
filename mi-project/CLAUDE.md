# mi-project — lab Terraform/Terragrunt en AWS

Lab de ~15 min, dentro del repo `fmoreno0207/workshop-sendati-iac`. El bucket del state y los roles OIDC
del pipeline los crea `../bootstrap` (a mano, una vez). Pipeline: `../.github` (PR = plan, main = aprobación + apply).

## Objetivo
EC2 chica + tabla DynamoDB que reutilizan lo que ya hay en la cuenta AWS, sin hardcodear IDs:
- VPC default + subnets vía data sources.
- AMI Amazon Linux 2023 vía parámetro SSM.
- Acceso por SSM Session Manager (rol IAM), sin SSH ni puerto 22.
- State en S3 (lock nativo, sin DynamoDB para locking).

## Estructura (patrón de ~/medife/foundation-iac, adaptado a AWS)
```
mi-project/
├── CLAUDE.md
├── .terraform-version        # 1.14.7 (exacta, igual que required_version)
├── .terragrunt-version       # 1.1.6
├── Makefile                  # plan/apply/destroy (ENTORNO=dev|qa, UNIDAD=iam-ssm|ec2|dynamodb)
├── modules/{iam-ssm,ec2,dynamodb}/   # variables, data (si hace falta), main, outputs, README
├── modules/{eks,rds,ecr,alb}/        # vacíos a propósito (pendientes)
├── live/root.hcl             # provider + backend S3; bucket = <prefijo>-sendati-tfstate (workshop-sendati-tfstate)
├── live/{dev,qa}/env.hcl     # valores del entorno (lo único que cambia)
└── live/{dev,qa}/{iam-ssm,ec2,dynamodb}/terragrunt.hcl  # ec2 → dependency iam-ssm (con mocks)
```

## Fases
0. Bootstrap (repo aparte) → 1. Descubrir (plan) → 2. Apply dev → 3. Reuso qa → 4. Destroy.
(La demo de import se sacó por ahora, a pedido del usuario.)

## Herramientas (verificado 2026-10-23)
- Terraform v1.14.7 · aws CLI OK.
- Terragrunt instalado: v0.67.0 (⚠️ viejo). El repo pide >= 1.1.6 (sintaxis 1.x,
  `terraform_binary = "terraform"` porque 1.x usa tofu por defecto).

## Reglas
- Solo lectura / plan hasta que el usuario apruebe `apply`.
- Nada hardcodeado: todo por data sources y variables.
- Todo Terraform/Terragrunt: nada de scripts bash (el usuario lo pidió explícitamente).
- Lo más limpio posible: comentarios cortos, data sources dentro de los módulos (data.tf).
- Instancias sin IP pública (SSM). No dejar nada prendido: cerrar con destroy.
- Ojo: sin IP pública y sin VPC endpoints, el agente SSM no tiene salida en la
  VPC default (no conecta). Ver README (sección SSM).
- El nombre del bucket se arma igual en `../bootstrap/live/env.hcl` y en `live/root.hcl`: si cambia uno, cambiar el otro.
