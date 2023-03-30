provider "aws" {
  region = "us-east-2"
  alias  = "parent"
}
provider "aws" {
  region = "us-east-2"
  alias  = "child"
  assume_role {
    role_arn = "arn:aws:iam::489335088683:role/OrganizationAccountAccessRole"
  }
}

module "multi_account_example" {
  source = "../../modules/multi-account"
  providers = {
    aws.parent = aws.parent
    aws.child  = aws.child
  }
}
