resource "aws_iam_role" "this" {
  name               = "${var.nombre}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = merge(var.tags, { Name = "${var.nombre}-role" })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.ssm_core.arn
}

# La EC2 usa el rol a través del instance profile.
resource "aws_iam_instance_profile" "this" {
  name = "${var.nombre}-profile"
  role = aws_iam_role.this.name

  tags = merge(var.tags, { Name = "${var.nombre}-profile" })
}
