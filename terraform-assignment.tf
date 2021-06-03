terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.43.0"
    }
  }
}

provider "aws" {
  access_key = "AKIAUZN5OLTOWTU6WOI7"
  secret_key = "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"
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  ami                         = "ami-010aff33ed5991201"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  ebs_optimized               = false
  key_name                    = "Terraform-new"
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  tags = {
    Name = "TerraForm-Instance-Tavish"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo service docker start",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:\\Users\\tavishgandhi\\OneDrive - Nagarro\\Desktop\\Terraform-new.pem")
      host        = aws_instance.web.public_ip

    }
  }
}

resource "aws_security_group" "ssh-sg" {
  name        = "ssh-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

output "instance_ip_addr" {
  value = aws_instance.web.public_ip
}
