resource "aws_s3_bucket" "receipt_bucket" {
  bucket = var.bucket_name
}

resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.receipt_bucket.arn
}

resource "aws_s3_bucket_notification" "receipt_upload_notification" {
  bucket = aws_s3_bucket.receipt_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.filter_prefix
  }

  depends_on = [aws_lambda_permission.allow_s3_invocation]
}

resource "aws_s3_object" "incoming_folder" {
  bucket = aws_s3_bucket.receipt_bucket.id
  key    = "incoming/"
  content = ""
}


resource "aws_s3_bucket_public_access_block" "receipt_bucket_public_access_block" {
  bucket = aws_s3_bucket.receipt_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_policy     = false
}
resource "aws_s3_bucket_versioning" "receipt_bucket_versioning" {
  bucket = aws_s3_bucket.receipt_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "receipt_bucket_lifecycle" {
  bucket = aws_s3_bucket.receipt_bucket.id

  rule {
    id     = "Expire old objects"
    status = "Enabled"

    expiration {
      days = 365
    }

    filter {
      prefix = var.filter_prefix
    }
  }
}

