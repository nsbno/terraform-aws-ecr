terraform {
  required_version = ">= 1.11.0"
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "ecr" {
  source      = "../../"
  name_prefix = var.name_prefix

  trusted_accounts = [
    data.aws_caller_identity.current.account_id
  ]

  tags = {
    environment = "dev"
    terraform   = "True"
  }
}
