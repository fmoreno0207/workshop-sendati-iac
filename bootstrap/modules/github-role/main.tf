resource "aws_iam_role" "this" {
  name               = var.nombre
  assume_role_policy = data.aws_iam_policy_document.confianza.json

  tags = merge(var.tags, { Name = var.nombre })
}

resource "aws_iam_role_policy_attachment" "administradas" {
  for_each = data.aws_iam_policy.administradas

  role       = aws_iam_role.this.name
  policy_arn = each.value.arn
}

# Permisos puntuales del rol.
resource "aws_iam_role_policy" "propia" {
  count = var.politica == null ? 0 : 1

  name   = "${var.nombre}-permisos"
  role   = aws_iam_role.this.id
  policy = var.politica
}
