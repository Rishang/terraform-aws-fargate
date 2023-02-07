terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }
}

# Configure the AWS Provider
# provider "aws" {
#   region = "eu-west-2"

#   default_tags {
#     tags = {
#       Environment = "Test"
#       Creator     = "Terraform"
#     }
#   }
# }
