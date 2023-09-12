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
    Name = "My Server"
  }

    lifecycle {
    prevent_destroy =  false //"true" - it will prevent from destroy, false will allow to delete the resource
  }

}

#Splat Output (All IP are shown as output)
output "All-Public-IP" {
  value = aws_instance.my_server.public_ip
}