output "vpc_id" {
  description = "VPC default reutilizada."
  value       = data.aws_vpc.default.id
}

output "subnet_id" {
  description = "Subnet elegida."
  value       = aws_instance.this.subnet_id
}

output "ami_id" {
  description = "AMI Amazon Linux 2023."
  value       = data.aws_ssm_parameter.al2023.insecure_value
}

output "instance_id" {
  description = "ID de la EC2."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "IP privada de la EC2."
  value       = aws_instance.this.private_ip
}
