provider "aws" {
  region = "us-east-1" 
}


resource "aws_dynamodb_table" "logs_table" {
  name         = "LogsTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "logId"
  range_key    = "timestamp"
  attribute {
    name = "logId"
    type = "S"
  }
  attribute {
    name = "timestamp"
    type = "S"
  }
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Lambda policy with DynamoDB access"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.logs_table.arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role     = aws_iam_role.lambda_role.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../src/lambda_function.zip"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "log_function" {
  filename         = "../src/lambda_function.zip"
  function_name    = "IncrementalLogFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.logs_table.name
    }
  }


}
