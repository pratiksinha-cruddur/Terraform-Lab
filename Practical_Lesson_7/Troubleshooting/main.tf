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
    Name = "${local.name}"
  }
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

locals {
  name = "Terraform Troubleshooting"
}


/* 
Use the give commands to see the log output in a file (in this case, it will be saved in 'terrform.log' file)

TF_LOG=TRACE terraform apply (show the TRACES IN CONSOLE)

TF_LOG=TRACE TF_LOG_PATH=./terraform.log terraform apply 

TF_LOG_PROVIDER=TRACE TF_LOG_PATH=./terraform.log terraform apply 

*/