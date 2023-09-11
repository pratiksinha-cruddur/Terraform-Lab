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
  //ami           = "ami-0f409bae3775dc8e5"
  ami           = "ami-01c647eace872fc02"
  instance_type = "t2.micro"
  depends_on = [
    aws_s3_bucket.my_bucket
  ]
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-test-bucket-by-psh"
  force_destroy = true
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

/* output "s3_bucket_arn" {
  value = aws_s3_bucket.my_bucket.s3_bucket_arn
}*/

/* output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.s3_bucket_id
}  */