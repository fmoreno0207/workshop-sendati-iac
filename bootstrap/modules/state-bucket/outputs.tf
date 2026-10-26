output "bucket" {
  description = "Nombre del bucket (backend de mi-project)."
  value       = aws_s3_bucket.this.bucket
}

output "arn" {
  description = "ARN del bucket."
  value       = aws_s3_bucket.this.arn
}
