data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

resource "aws_security_group" "ec2_security_group" {
  vpc_id = var.security_group_vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${chomp(data.http.my_ip.response_body)}/32" ]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "${chomp(data.http.my_ip.response_body)}/32" ]
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
  subnet_id = var.ec2_subnet_id
  key_name = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = var.instance_profile
    
  user_data = <<-EOF
                  #!/bin/bash       
                  yum install ansible nc -y
                  cd /home/ec2-user/ && git clone https://github.com/SkrytaModliszka/gitops-project.git
                  export ANSIBLE_HOST_KEY_CHECKING=False

                  ansible-playbook /home/ec2-user/gitops-project/ansible/playbooks/bastion/bastion_init.yaml
                  ansible-playbook -i /home/ec2-user/gitops-project/ansible/dynamic_inventory.sh /home/ec2-user/gitops-project/ansible/playbooks/app/*
                
                EOF
  
  tags = {
    Name = "${var.env}_${var.ec2_name_tag}_instance"
    Env = "${var.env}"
  }
}