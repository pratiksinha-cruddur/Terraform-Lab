terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-0df5d9a4e598287d5"
}

locals {
  ingress = [{
    port = 443
    protocol = "tcp"
    description = "Dynamic block HTTPS port 443"
    name = "Secure HTTPS 443 Traffic"
    },
    {
    port = 80
    protocol = "tcp"
    description = "Dynamic block HTTP port 80"
    name = "HTTPS 80 Traffic"
    },
    {
    port = 65521
    protocol = "tcp"
    description = "Dynamic block CUSTOM ingress port 65521"
    name = "Specific Port opened for Security"
    },
    {
    port = 22
    protocol = "tcp"
    description = "SSH port 22"
    name = "SSH Port 22"
    }
  ]
}

resource "aws_security_group" "my-sg" {
  name        = "My Security Group"
  description = "Allow TLS and Custom inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description      = ingress.value.description
      #name             = ingress.value.name
      prefix_list_ids  = []
      self             = false
      security_groups  = []
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = [data.aws_vpc.main.cidr_block]
      ipv6_cidr_blocks = []
    }
  }

  egress {
    description      = "Outbound traffic from VPC"
    prefix_list_ids  = []
    self             = false
    security_groups  = []
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Terraform SG"
  }
}