terraform {
  backend "s3" {
    bucket = "guards-get-terraform-state"
    key    = "demo.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
