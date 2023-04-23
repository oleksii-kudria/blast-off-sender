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
  runtime       = "python3.8"

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