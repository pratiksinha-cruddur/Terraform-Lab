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
  count = 2 #Number of EC2 Instances to be created, here it is 2 EC2
  
    tags = {
    Name = "My Server ${count.index}"
  }
}

output "Server-1-public_ip" {
  value = aws_instance.my_server[0].public_ip
}

output "Server-2-public_ip" {
  value = aws_instance.my_server[1].public_ip
}

#Splat Output (All IP are shown as output)
output "All-Public-IP" {
  value = aws_instance.my_server[*].public_ip
}