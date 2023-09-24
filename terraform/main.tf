provider "aws" {
  region              = var.aws_region
  allowed_account_ids = var.allowed_account_ids
}

locals {
  tags = {
    Name = var.name
  }
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  rules = {
    crons = {
      description         = "Trigger for a ${var.name} Lambda"
      schedule_expression = "rate(5 minutes)"
    }
  }

  targets = {
    crons = [
      {
        name  = "${var.name}-lambda-loves-cron"
        arn   = module.lambda.lambda_function_arn
        input = jsonencode({ "job" : "cron-by-rate" })
      }
    ]
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "${var.name}-lambda"
  handler       = "handler.handler"
  runtime       = "python3.10"

  environment_variables = {
    BUCKET = "${var.name}-s3"
  }

  source_path = "../src/sender"

  cloudwatch_logs_retention_in_days = 14

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["crons"]
    }
  }
}

resource "aws_dynamodb_table" "blast-dynamodb" {
  name             = "blast-dynamodb"
  hash_key         = "ID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "ID"
    type = "S"
  }

  #  lifecycle {
  #   prevent_destroy = true
  # }
}

data "aws_iam_policy_document" "lambda_ro_accsess_to_dynamodb" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:ConditionCheckItem"
    ]

    resources = [aws_dynamodb_table.blast-dynamodb.arn]
  }
}

resource "aws_iam_policy" "lambda_ro_accsess_to_dynamodb" {
  name = "lambda_ro_accsess_to_dynamodb"
  policy = data.aws_iam_policy_document.lambda_ro_accsess_to_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda_ro_accsess_to_dynamodb" {
  role = "${var.name}-lambda"
  policy_arn = aws_iam_policy.lambda_ro_accsess_to_dynamodb.arn
}