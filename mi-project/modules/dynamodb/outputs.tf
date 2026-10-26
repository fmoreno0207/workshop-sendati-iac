output "nombre" {
  description = "Nombre de la tabla."
  value       = aws_dynamodb_table.this.name
}

output "arn" {
  description = "ARN de la tabla."
  value       = aws_dynamodb_table.this.arn
}
