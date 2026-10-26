output "arn" {
  description = "ARN del proveedor OIDC."
  value       = aws_iam_openid_connect_provider.github.arn
}
