terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.48.0"
    }
  }
  required_version = ">= 1.11.0"
}

terraform {
  required_version = ">= 1.11.0"
}

provider "aws" {
  region = "eu-west-1"
}
