
resource "aws_lambda_function" "receipt_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_receipt_exec_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  filename         = var.lambda_source_path
  source_code_hash = filebase64sha256(var.lambda_source_path)

  timeout = var.lambda_timeout

  environment {
    variables = {
      DYNAMODB_TABLE      = var.dynamodb_table_name
      SES_SENDER_EMAIL    = var.SES_SENDER_EMAIL
      SES_RECIPIENT_EMAIL = var.SES_RECIPIENT_EMAIL
    }
  }
}

resource "aws_iam_role" "lambda_receipt_exec_role" {
  name = "receipt_lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.lambda_receipt_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.lambda_receipt_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "textract_full_access" {
  role       = aws_iam_role.lambda_receipt_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
}

resource "aws_iam_role_policy_attachment" "ses_full_access" {
  role       = aws_iam_role.lambda_receipt_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess" 
}

resource "aws_iam_role_policy_attachment" "basic_lambda_execution" {
  role       = aws_iam_role.lambda_receipt_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "terraform_user_policy" {
  name        = "TerraformUserLambdaSesPolicy"
  description = "Permissions for Lambda and SES"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:ListVersionsByFunction",
          "lambda:GetFunction",
          "lambda:ListFunctions",
          "lambda:GetFunctionConfiguration"
        ],
        Resource = "arn:aws:lambda:us-east-2:864981735718:function:receiptUploadLambda"
      },
      {
        Effect = "Allow",
        Action = [
          "ses:ListIdentities",
          "ses:GetIdentityVerificationAttributes"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "terraform_user_policy_attachment" {
  user       = "terraform_user"
  policy_arn = aws_iam_policy.terraform_user_policy.arn
}


