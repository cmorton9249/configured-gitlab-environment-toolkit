terraform {
  backend "s3" {
    bucket = "<state_aws_storage_bucket_name>"
    key    = "<state_aws_storage_file_name>.tfstate"
    region = "<aws_region>"
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
