resource "aws_iam_role" "main" {
  name_prefix = "${var.name_prefix}-vpn-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "main" {
  name_prefix = "${var.name_prefix}-vpn-profile-"
  role        = aws_iam_role.main.name

  lifecycle {
    create_before_destroy = true
  }
}
