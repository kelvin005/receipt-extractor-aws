provider "aws" {
  region = "us-east-2"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

}

module "s3" {
  source               = "./s3"
  bucket_name          = "receipt-bucket-kelechi"
  lambda_function_name = module.lambda.lambda_function_name
  lambda_function_arn  = module.lambda.lambda_function_arn
  filter_prefix        = "incoming/"
}

module "dynamodb" {
  source     = "./dynamodb"
  table_name = "Receipts"
}
module "ses" {
  source     = "./ses"
  sender_email = "sundaykelechi115@gmail.com"

}

module "lambda" {
  source              = "./lambda"
  lambda_function_name = "receiptUploadLambda"
  lambda_handler       = "receipt-app-func.lambda_handler"
  lambda_runtime       = "python3.9"
  lambda_source_path   = "${path.module}/lambda/function.zip"
  lambda_timeout       = 180
  dynamodb_table_name  = module.dynamodb.dynamodb_table_name
  SES_SENDER_EMAIL    = "sundaykelechi115@gmail.com"
  SES_RECIPIENT_EMAIL  = "sundaykelechi115@gmail.com"
}


