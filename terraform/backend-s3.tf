terraform {
  backend "s3" {
    bucket = "blast-off-terraformstate"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-blast-off-sender"
    encrypt = true
  }
}