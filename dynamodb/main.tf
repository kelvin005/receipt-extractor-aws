resource "aws_dynamodb_table" "receipt_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "receipt_id"
  range_key = "date"

  attribute {
    name = "receipt_id"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }
}
