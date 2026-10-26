# iam-ssm

Rol IAM + instance profile para que la EC2 use SSM.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| aws_iam_instance_profile.this | resource |
| aws_iam_role.this | resource |
| aws_iam_role_policy_attachment.ssm_core | resource |
| aws_iam_policy.ssm_core | data source |
| aws_iam_policy_document.assume | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| nombre | Prefijo de los nombres. | `string` | n/a | yes |
| tags | Tags del entorno. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_profile_name | Instance profile para el módulo ec2. |
| role_arn | ARN del rol. |
<!-- END_TF_DOCS -->
