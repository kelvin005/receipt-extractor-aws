provider "aws" {
  region = "us-east-2"
}


resource "aws_ses_email_identity" "sender" {
  email = var.sender_email
}
