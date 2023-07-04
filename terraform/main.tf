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


resource "aws_s3_bucket" "example" {
  bucket = "${var.name}-s3"

  tags = {
    Name = "blast-off-sender-s3"
  }
}

data "aws_iam_policy_document" "lambda_ro_accsess_to_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
    ]

    resources = ["arn:aws:s3:::${var.name}-s3/*"]
  }
}

resource "aws_iam_policy" "lambda_ro_accsess_to_s3" {
  name = "lambda_ro_accsess_to_s3"
  policy = data.aws_iam_policy_document.lambda_ro_accsess_to_s3.json
}

resource "aws_iam_role_policy_attachment" "lambda_ro_accsess_to_s3" {
  role = "${var.name}-lambda"
  policy_arn = aws_iam_policy.lambda_ro_accsess_to_s3.arn
}