terraform {
  backend "s3" {
    bucket         = "terraform-infrastructure-state"
    key            = "elasticsearch/infrastructure-nonprod/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-infrastructure-state-dynamodb-table"
  }
}