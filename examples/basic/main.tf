data "aws_caller_identity" "current" {}

module "ecr" {
  source    = "../../"
  repo_name = "ecr-basic-example"

  trusted_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}
