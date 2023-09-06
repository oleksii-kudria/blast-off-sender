# resource "aws_dynamodb_table" "terraform_locks"{
#   name = "terraform-blast-off-sender"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

terraform {
  backend "s3" {
    bucket = "blast-off-terraformstate"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
    # dynamodb_table = "terraform-blast-off-sender"
    # encrypt = true
  }
}