# VPC default de la región.
data "aws_vpc" "default" {
  default = true
}

# AZs donde existe el tipo de instancia.
data "aws_ec2_instance_type_offerings" "tipo" {
  location_type = "availability-zone"

  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
}

# Subnets de la VPC default en esas AZs.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = data.aws_ec2_instance_type_offerings.tipo.locations
  }
}

# AMI Amazon Linux 2023 (parámetro público de SSM).
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
