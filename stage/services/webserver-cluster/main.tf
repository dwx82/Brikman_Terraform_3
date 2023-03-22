provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-v3-state"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

/*
if you needed to expose an extra port in just the staging environment (e.g.,
for testing),
resource "aws_security_group_rule" "allow_testing_inbound" {
type = "ingress"
security_group_id = module.webserver_cluster.alb_security_group_id
from_port = 12345
to_port = 12345
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
*/
#---------------------------------backend-----------------------------------------

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-v3-state"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-state"
    encrypt        = true
  }
}
