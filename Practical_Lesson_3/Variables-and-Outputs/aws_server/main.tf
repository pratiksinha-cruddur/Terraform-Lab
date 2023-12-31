terraform {
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

variable "instance_type" {
  type    = string
  description = "Enter Instance type e.g. (t2.small/t2.micro/m1.small)"
  //sensitive = false
  validation {
    condition = can(regex("^t2.", var.instance_type))
    error_message = "Entered Instance type must be valid and must start with t2." 
  }
}

variable "ami" {
  type    = string
  description = "AMI For the Instance type "
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type

  tags = {
    Name = "Terraform ${local.project_name}"
    Other_Name = "${local.sub_project_name}"
  }
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

locals {
  project_name = "Submodules"
  sub_project_name = "Local Variables"
}