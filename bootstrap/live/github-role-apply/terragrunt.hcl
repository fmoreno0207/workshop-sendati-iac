# bootstrap/live/github-role-apply/terragrunt.hcl
# Rol del apply: solo desde los environments de GitHub (con aprobación) y solo recursos del lab.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env     = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  repo    = local.env.github_repo
  cuenta  = local.env.cuenta
  region  = local.env.region
  prefijo = local.env.name_prefix
  oidc    = "arn:aws:iam::${local.cuenta}:oidc-provider/token.actions.githubusercontent.com"
  tags    = merge(local.env.tags_base, { Componente = "github-apply" })

  rol_ssm    = "arn:aws:iam::${local.cuenta}:role/${local.prefijo}-*-ssm-role"
  perfil_ssm = "arn:aws:iam::${local.cuenta}:instance-profile/${local.prefijo}-*-ssm-profile"
}

terraform {
  source = "../../modules/github-role"
}

dependency "oidc" {
  config_path = "../github-oidc"

  # El ARN real es fijo: se usa para planear antes de crear el proveedor.
  mock_outputs                            = { arn = local.oidc }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show", "destroy"]
}

inputs = {
  nombre            = "${local.prefijo}-github-apply"
  oidc_provider_arn = dependency.oidc.outputs.arn

  sujetos = [for e in local.env.entornos : "repo:${local.repo}:environment:${e}"]

  politicas = ["ReadOnlyAccess"]

  politica = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "State"
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${local.env.state_bucket}/*"
      },
      {
        Sid    = "Ec2DelLab"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances", "ec2:TerminateInstances", "ec2:StartInstances", "ec2:StopInstances",
          "ec2:ModifyInstanceAttribute", "ec2:ModifyInstanceMetadataOptions", "ec2:ModifyInstanceCreditSpecification",
          "ec2:AssociateIamInstanceProfile", "ec2:DisassociateIamInstanceProfile", "ec2:ReplaceIamInstanceProfileAssociation",
          "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup", "ec2:ModifySecurityGroupRules",
          "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:CreateTags", "ec2:DeleteTags",
        ]
        Resource  = "*"
        Condition = { StringEquals = { "aws:RequestedRegion" = local.region } }
      },
      {
        Sid    = "RolesSsmDelLab"
        Effect = "Allow"
        Action = [
          "iam:CreateRole", "iam:DeleteRole", "iam:UpdateRole", "iam:UpdateAssumeRolePolicy", "iam:TagRole", "iam:UntagRole",
          "iam:CreateInstanceProfile", "iam:DeleteInstanceProfile", "iam:TagInstanceProfile", "iam:UntagInstanceProfile",
          "iam:AddRoleToInstanceProfile", "iam:RemoveRoleFromInstanceProfile",
        ]
        Resource = [local.rol_ssm, local.perfil_ssm]
      },
      {
        Sid       = "SoloPoliticaSsm"
        Effect    = "Allow"
        Action    = ["iam:AttachRolePolicy", "iam:DetachRolePolicy"]
        Resource  = local.rol_ssm
        Condition = { ArnEquals = { "iam:PolicyARN" = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" } }
      },
      {
        Sid       = "PassRoleSoloEc2"
        Effect    = "Allow"
        Action    = "iam:PassRole"
        Resource  = local.rol_ssm
        Condition = { StringEquals = { "iam:PassedToService" = "ec2.amazonaws.com" } }
      },
      {
        Sid    = "TablasDelLab"
        Effect = "Allow"
        Action = [
          "dynamodb:CreateTable", "dynamodb:DeleteTable", "dynamodb:UpdateTable",
          "dynamodb:TagResource", "dynamodb:UntagResource",
          "dynamodb:UpdateTimeToLive", "dynamodb:UpdateContinuousBackups",
        ]
        Resource = "arn:aws:dynamodb:${local.region}:${local.cuenta}:table/${local.prefijo}-*"
      },
    ]
  })

  tags = local.tags
}
