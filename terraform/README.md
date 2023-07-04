# blast-off-sender Terraform

- Lambda Function
- S3 bucket for downloads
- Amazon EventBridge

## Deployments

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 2.0 |
| <a name="module_records"></a> [records](#module\_eventbridge) | terraform-aws-modules/eventbridge/aws | ~> 2.0 |

## Resources

| Resource | Description|
|------|---------|
| <a name="aws_s3_bucket"></a> [aws_s3_bucket] (#resource\_aws_s3_bucket) | Provides a S3 bucket resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_account_ids"></a> [allowed\_account\_ids](#input\_allowed\_account\_ids) | List of allowed AWS acount ids where infrastructure will be created | `list(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where infrastructure will be created | `string` | `"eu-central-1"` | no |

## Outputs