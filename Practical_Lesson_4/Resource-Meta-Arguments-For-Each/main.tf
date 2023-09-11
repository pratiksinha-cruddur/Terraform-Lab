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
  for_each = {
    nano = "t2.nano"
    micro = "t2.micro"
    small = "t2.small"
    medium = "t2.medium"
  }
  ami           = "ami-01c647eace872fc02"
  instance_type = each.value
  
    tags = {
    Name = "My Server ${each.key}"
  }
}

#Splat Output (All IP are shown as output)
output "All-Public-IP" {
  value = values(aws_instance.my_server)[*].public_ip
}
