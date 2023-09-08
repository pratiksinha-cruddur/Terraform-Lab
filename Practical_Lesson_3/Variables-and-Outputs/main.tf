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
    condition = can(regex("^t3.", var.instance_type))
    error_message = "Entered Instance type must be valid and must start with t3." 
  }
}

variable "ami" {
  type    = string
  description = "AMI For the Instance type "
}

resource "aws_instance" "terraform-lab" {
  ami                    = var.ami
  instance_type          = var.instance_type

  tags = {
    Name = "Terraform ${local.project_name}"
  }
}

output "public_ip" {
  value = aws_instance.terraform-lab.public_ip
}

locals {
  project_name = "Variables and Outputs"
}