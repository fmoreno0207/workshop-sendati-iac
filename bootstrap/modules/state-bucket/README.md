# state-bucket

Bucket S3 para el state: versionado, cifrado y sin acceso público.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| aws_s3_bucket.this | resource |
| aws_s3_bucket_public_access_block.this | resource |
| aws_s3_bucket_server_side_encryption_configuration.this | resource |
| aws_s3_bucket_versioning.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| nombre | Nombre del bucket (único en todo S3). | `string` | n/a | yes |
| tags | Tags base. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN del bucket. |
| bucket | Nombre del bucket (backend de mi-project). |
<!-- END_TF_DOCS -->
