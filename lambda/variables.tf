variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}


variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime environment"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_source_path" {
  description = "Path to lambda deployment zip"
  type        = string
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 180
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "SES_SENDER_EMAIL" {
  description = "SES sender email"
  type        = string
}

variable "SES_RECIPIENT_EMAIL" {
  description = "SES recipient email"
  type        = string
}
