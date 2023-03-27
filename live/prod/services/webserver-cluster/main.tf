provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running-v3-state"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "terraform"
  }
}

#---------------------------------backend-----------------------------------------

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-v3-state"
    key    = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-state"
    encrypt        = true
  }
}
