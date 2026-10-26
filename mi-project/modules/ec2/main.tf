# Sin reglas de entrada.
resource "aws_security_group" "this" {
  name        = "${var.nombre}-sg"
  description = "Sin entrada; salida HTTPS para SSM"
  vpc_id      = data.aws_vpc.default.id

  tags = merge(var.tags, { Name = "${var.nombre}-sg" })
}

# Salida HTTPS para el agente SSM.
resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(var.tags, { Name = "${var.nombre}-sg-https" })
}

resource "aws_instance" "this" {
  ami                         = data.aws_ssm_parameter.al2023.insecure_value
  instance_type               = var.instance_type
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = var.instance_profile
  associate_public_ip_address = false # sin costo de IPv4

  # Evita cargos por CPU extra en t3.
  credit_specification {
    cpu_credits = "standard"
  }

  tags = merge(var.tags, { Name = var.nombre })
}
