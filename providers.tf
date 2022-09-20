terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.61"
    }
  }
}
provider "aws" {
  region     = "us-west-2"
  access_key = "AKIA3ASUVGAISDAQ7AZD"
  secret_key = "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"
}