variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function to invoke"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
}

variable "filter_prefix" {
  description = "S3 event filter prefix (optional)"
  type        = string
  default     = "incoming/"
}
