output "instance_profile_name" {
  description = "Instance profile para el módulo ec2."
  value       = aws_iam_instance_profile.this.name
}

output "role_arn" {
  description = "ARN del rol."
  value       = aws_iam_role.this.arn
}
