# github-role

Rol IAM que GitHub Actions asume por OIDC, limitado a los `sujetos` indicados.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| aws_iam_role.this | resource |
| aws_iam_role_policy.propia | resource |
| aws_iam_role_policy_attachment.administradas | resource |
| aws_iam_policy.administradas | data source |
| aws_iam_policy_document.confianza | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| nombre | Nombre del rol. | `string` | n/a | yes |
| oidc_provider_arn | ARN del proveedor OIDC de GitHub. | `string` | n/a | yes |
| politica | Política propia en JSON (null = ninguna). | `string` | `null` | no |
| politicas | Nombres de políticas administradas de AWS. | `list(string)` | `[]` | no |
| sujetos | Claims sub permitidos (ej.: repo:org/repo:pull_request). | `list(string)` | n/a | yes |
| tags | Tags base. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN del rol (va en las variables de GitHub). |
<!-- END_TF_DOCS -->
