terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Authentication to the AWS account is done via IAM user secrets.  This would scale better (and be more secure) with Identity Management 
# via IAM Identity Center using a tokenized solution.
provider "aws" {
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}
