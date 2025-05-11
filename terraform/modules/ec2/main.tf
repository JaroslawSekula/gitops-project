resource "aws_security_group" "ec2_security_group" {
  vpc_id = var.security_group_vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.ingress_cidr ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "${var.env}_${var.ec2_name_tag}_security_group"
  }
}

resource "aws_instance" "ec2_instance" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]
  key_name = var.key_name
  subnet_id = var.ec2_subnet_id
  associate_public_ip_address = false
  
  tags = {
    Name = "${var.env}_${var.ec2_name_tag}_instance"
    Env = var.env
  }
}