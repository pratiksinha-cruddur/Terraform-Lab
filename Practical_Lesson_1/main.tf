terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "pratiksinha-org"

    workspaces {
      name = "getting-started"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

locals {
  project_name = "Pratik Sinha"
}