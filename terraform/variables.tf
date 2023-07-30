variable "allowed_account_ids" {
  description = "List of allowed AWS acount ids where infrastructure will be created"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region where infrastructure will be created"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name or prefix for many related resources"
  type        = string
  default     = "blast-off-sender"
}