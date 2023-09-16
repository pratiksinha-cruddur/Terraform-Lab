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





######################################################################################################


# outside resources for importing (bucket 'pratiksinha' created manually outside of Terraform)
resource "aws_s3_bucket" "import" {
    bucket = "pratiksinha"
}


# use this command to import the above "terraform import aws_s3_bucket.import pratiksinha"

#terraform destroy (Now you can delete the manually created bucket)
######################################################################################################





resource "aws_s3_bucket" "example" {
  bucket        = "my-tf-test-bucket-pratik-sinha"
  force_destroy = true

  tags = {
    name = "${local.s3-bucket-name}"
  }
}



output "Server-1-public_ip" {
  value = aws_instance.my_server.public_ip
}

locals {
  name = "Terraform Resource Drift (Also known as Drift Detection in AWS CloudFormation)"
  s3-bucket-name = "My Terraform bucket"
}