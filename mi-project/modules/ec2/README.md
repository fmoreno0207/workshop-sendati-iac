# ec2

EC2 sin IP pública en la VPC default, con un SG sin reglas de entrada.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| aws_instance.this | resource |
| aws_security_group.this | resource |
| aws_vpc_security_group_egress_rule.https | resource |
| aws_ec2_instance_type_offerings.tipo | data source |
| aws_ssm_parameter.al2023 | data source |
| aws_subnets.default | data source |
| aws_vpc.default | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_profile | Instance profile del módulo iam-ssm. | `string` | n/a | yes |
| instance_type | Tipo de instancia (capa gratuita). | `string` | `"t3.micro"` | no |
| nombre | Nombre de la instancia y prefijo del SG. | `string` | n/a | yes |
| tags | Tags del entorno. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ami_id | AMI Amazon Linux 2023. |
| instance_id | ID de la EC2. |
| private_ip | IP privada de la EC2. |
| subnet_id | Subnet elegida. |
| vpc_id | VPC default reutilizada. |
<!-- END_TF_DOCS -->
