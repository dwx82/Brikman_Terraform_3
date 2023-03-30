provider "aws" {
  region = "us-east-2"
  alias  = "primary"
}
provider "aws" {
  region = "us-west-1"
  alias  = "replica"
}
module "mysql_primary" {
  source = "../../../../modules/data-stores/mysql"

  providers = {
    aws = aws.primary
  }
  db_name     = "prod_db"
  db_username = var.db_username
  db_password = var.db_password
  # Must be enabled to support replication
  backup_retention_period = 1
}

module "mysql_replica" {
  source = "../../../../modules/data-stores/mysql"

  providers = {
    aws = aws.replica
  }

  # Make this a replica of the primary
  replicate_source_db = module.mysql_primary.arn
}

# Replace this with your DynamoDB table name & bucket name!
terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-v3-state"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-state"
    encrypt        = true
  }
}
