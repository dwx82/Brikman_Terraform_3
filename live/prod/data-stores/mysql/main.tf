provider "aws" {
  region = "us-east-2"
}

/*if you don’t disable the snapshot, or don’t provide a name for the snapshot via the final_snapshot_identifier parameter, destroy will fail.
For the db_username and db_password input variables,
here is how you can set the TF_VAR_db_username and TF_VAR_db_password environment
variables on Linux/Unix/macOS systems:
$ export TF_VAR_db_username="(YOUR_DB_USERNAME)"
$ export TF_VAR_db_password="(YOUR_DB_PASSWORD)"
*/
resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = var.db_username
  password = var.db_password
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
