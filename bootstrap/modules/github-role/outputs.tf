output "arn" {
  description = "ARN del rol (va en las variables de GitHub)."
  value       = aws_iam_role.this.arn
}
