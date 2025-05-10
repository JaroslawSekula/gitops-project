resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_iam_policy" "iam_policy" {
  name = "dynamic_permissions_${random_id.suffix.hex}"
  description = "Dynamically generated permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        for permission in var.permissions : {
            Effect = "Allow"
            Action = "${permission}"
            Resource = "${var.resource}"
        }
    ]
  })
}

resource "aws_iam_role" "iam_role" {
  name = "dynamic_role_${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "${var.effect}"
        Principal = {
            Service = "${var.service}"
        },
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "dynamic_profile_${random_id.suffix.hex}"
  role = aws_iam_role.iam_role.name
}
