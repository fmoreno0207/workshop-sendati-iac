# mi-project: Terraform + Terragrunt en AWS

EC2 `t3.micro` accesible por SSM y una tabla DynamoDB, reutilizando la VPC default y sin IDs a mano.
Mismo patrón que los repos foundation de Medifé. El bucket del state lo crea el repo `bootstrap`.

## ⚠️ Costos

- `t3.micro` entra en la capa gratuita (750 h/mes sumando todas las instancias). Para verificarlo:
  `aws ec2 describe-instance-types --filters Name=free-tier-eligible,Values=true --query 'InstanceTypes[].InstanceType'`
- No tiene IP pública, así que no hay cargo por IPv4. La CPU está en modo `standard`, sin cargos extra.
- DynamoDB con 1 lectura / 1 escritura: entra en la capa gratuita.
- **Siempre cerrar con `destroy`.**

## ⚠️ SSM

Sin IP pública, la instancia no tiene salida a internet y no aparece en Session Manager.
Para conectarse, cambiá a `associate_public_ip_address = true` en `modules/ec2/main.tf` (~USD 0,005/h).

## Requisitos

- `../bootstrap` ya corrido (crea el bucket del state)
- Terraform 1.14.7 ([.terraform-version](.terraform-version))
- Terragrunt ≥ 1.1.6 ([.terragrunt-version](.terragrunt-version))
- AWS CLI v2 con credenciales

## Estructura

```
modules/
├── iam-ssm/       # rol + instance profile
├── ec2/           # SG + EC2
├── dynamodb/      # tabla NoSQL
├── eks/           # pendiente
├── rds/           # pendiente
├── ecr/           # pendiente
└── alb/           # pendiente
live/
├── root.hcl       # provider + backend S3
├── dev/           # env.hcl, iam-ssm/, ec2/, dynamodb/
└── qa/            # igual que dev, solo cambia env.hcl
```

Cada módulo tiene `variables.tf`, `data.tf` (solo si lo necesita), `main.tf` y `outputs.tf`.

## Pasos

En el repo, los cambios van por PR y los aplica el pipeline (ver `../README.md`). A mano, para probar:

```bash
# 1. Descubrir: lee VPC, subnet y AMI, no crea nada
make plan

# 2. Crear dev
make apply

# 3. Reusar en qa
make plan ENTORNO=qa
make apply ENTORNO=qa

# 4. Destruir
make destroy ENTORNO=qa
make destroy ENTORNO=dev
make clean
```
