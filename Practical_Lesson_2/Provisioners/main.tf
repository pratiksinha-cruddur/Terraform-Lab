terraform {
  /*cloud {
    organization = "pratiksinha-org"

    workspaces {
      name = "provisioners"
    }
  }*/

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-0df5d9a4e598287d5"
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDup83PJ7Jb99/NSSLzvWDhKwSIYD4FjSBg5dgKp+BKJ2EuTXPccy4yHSXVaOmAArGMu6YE31YqOpDcnildAEjxb0qTFEfIufpiaMPXbpkmsyJxUbUbHNPu0TgCUgPHmBxDTplzOb+CuM11QVX2tkaaERhF4TRkjpwuXfv4MTuj/9/oMqlLQ3LqKUXdbfLJYKWlrLLPQlll8nvLnB3m9MO61+Hl5iClxOEBrcyJ5EgNYnVyYjbGWmWwfzCzrltBlhOMULiLss0N2seWLfuyODMltg3zwrL/CosU/hAGehK23EubpwLbc6I38wdxKg2qSMDH3s0gzFRWOZqVKcIWgU/PvYVB0c8rVjZe+80A2085mT9Das3GwGk+rt1+jytlwr2sp+jRapfKTSr+5JufMegLISkMjcsNIOSyt/OqEIpQIU6dHQlR9rzoWVzcCCD3mkyEWbW9Don9G5Nb1KIfG60hb2hMEkz/W/P9LsJ8+CJH9mFldJW6bWEvmTD3/PtSxU= User@Lenovo-PC"
}


resource "aws_instance" "terraform-lab" {
  ami                    = "ami-0f409bae3775dc8e5"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg-my-server.id]
  user_data              = data.template_file.user_data.rendered

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("C:/Users/User/.ssh/terraform")}"
    host     = self.public_ip
  }

  provisioner "file" {
    content     = "ami used: ${self.ami}"
    destination = "/home/ec2-user/output.txt"
  }
  
  /* provisioner "remote-exec" {
    inline = [
      "echo ${self.private_ip} >> /home/ec2-user/private_ips.txt"
    ]
  } */

  tags = {
    Name = "Terraform-${local.project_name}"
  }
}

resource "aws_security_group" "sg-my-server" {
  name        = "HTTP_SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["115.187.62.191/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      description      = "SG Outbound Rules"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}


locals {
  project_name = "Provisioners-Lab-2"
}

output "public_ip" {
  value = aws_instance.terraform-lab.public_ip
}