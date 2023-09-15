terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_server" {
  ami           = "ami-01c647eace872fc02"
  instance_type = "t2.micro"
  
    tags = {
    Name = "My Server ${local.name}"
    Output = "${local.sample}"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-pratik-sinha"
  force_destroy = true  
}

output "Server-1-public_ip" {
  value = aws_instance.my_server.public_ip
}

#Splat Output (All IP are shown as output)
output "All-Public-IP" {
  value = aws_instance.my_server[*].public_ip
}

locals {
  name = "in Terraform State"
  sample = "Check 'terraform.tfstate' file"
}