# Tabla NoSQL. 1 lectura / 1 escritura: dentro de la capa gratuita.
resource "aws_dynamodb_table" "this" {
  name           = var.nombre
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = var.clave

  attribute {
    name = var.clave
    type = "S"
  }

  tags = merge(var.tags, { Name = var.nombre })
}
