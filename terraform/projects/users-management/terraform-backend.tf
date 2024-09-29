terraform {
  backend "s3" {
    bucket         = "terraform-infrastructure-state"
    key            = "elasticsearch/users-management/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-infrastructure-state-dynamodb-table"
  }
}