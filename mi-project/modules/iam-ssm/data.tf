# Permite que EC2 asuma el rol.
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Política de AWS para SSM, buscada por nombre.
data "aws_iam_policy" "ssm_core" {
  name = "AmazonSSMManagedInstanceCore"
}
