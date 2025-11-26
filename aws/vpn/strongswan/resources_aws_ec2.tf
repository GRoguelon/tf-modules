resource "aws_instance" "main" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.main.name
  source_dest_check      = false # Required for VPN routing
  user_data_base64       = data.cloudinit_config.main.rendered

  tags = {
    Name = "${var.name_prefix}-vpn"
  }

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}

resource "aws_eip" "main" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-vpn"
  }
}

resource "aws_eip_association" "main" {
  allocation_id = aws_eip.main.id
  instance_id   = aws_instance.main.id
}
