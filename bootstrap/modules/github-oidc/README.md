# github-oidc

Proveedor OIDC de GitHub Actions en AWS: el pipeline entra sin claves.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| aws_iam_openid_connect_provider.github | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | Tags base. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN del proveedor OIDC. |
<!-- END_TF_DOCS -->
