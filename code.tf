provider "aws" {
  region = "ap-south-1" 
  #shared_credentials_file = "C:/Users//aws_credentials"
  access_key = "XXXX"
  secret_key = "XXXX"
}

resource "aws_security_group" "basic_security" {
  name        = "airbus-codech-sg"
  ingress {
    description      = "Allow all inbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_airbus-jenkins" {
   ami = "ami-04a223c5825a793bc"
   root_block_device {
    volume_size = 10
  }
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.basic_security.id]
   key_name = "ec2-keypair-airbus"
  tags = {
    Name = "ec2_airbus-jenkins"
  }
}

output "public-ip-address" {
  value       = "${aws_instance.ec2_airbus-jenkins.*.public_ip}"
  description = "Public address details"
}

resource "aws_instance" "ec2_airbus" {
   ami = "ami-04a223c5825a793bc"
   root_block_device {
    volume_size = 10
  }
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.basic_security.id]
   key_name = "ec2-keypair-airbus"
   user_data = <<EOF
#!/bin/bash -xe
sudo -i
sudo amazon-linux-extras install ansible2 -y
yum install git python python-pip python-level openssl -y
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
mkdir ansible-playbook
cd ansible-playbook/
git clone https://github.com/1997NikhilM/Airbus.git
EOF
  tags = {
    Name = "ec2_airbus"
  }
}
#echo "[server]" >> /etc/ansible/hosts
#echo "52.66.25.220 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/.ssh/id_rsa ansible_python_interpreter=/usr/bin/python2.7" >> /etc/ansible/hosts
#ansible-playbook linux-java-jenkins.yml

