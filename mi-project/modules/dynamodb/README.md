# dynamodb

Tabla DynamoDB (NoSQL) con capacidad mínima, dentro de la capa gratuita.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| aws_dynamodb_table.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| clave | Clave de partición (string). | `string` | `"id"` | no |
| nombre | Nombre de la tabla. | `string` | n/a | yes |
| tags | Tags del entorno. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN de la tabla. |
| nombre | Nombre de la tabla. |
<!-- END_TF_DOCS -->
