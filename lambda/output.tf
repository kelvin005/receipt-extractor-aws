output "lambda_function_name" {
  value = aws_lambda_function.receipt_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.receipt_lambda.arn
}
