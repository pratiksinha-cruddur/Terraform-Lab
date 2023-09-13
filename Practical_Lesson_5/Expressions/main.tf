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

variable "hello" {
    type = list
}

variable "name" {
    type = string
}

variable "worlds_maps" {
    type = map
}

variable "worlds_splat" {
    type = list
}