variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "lambda_function_zip" {
  description = "Path to the Lambda function ZIP file"
  default     = "../src/lambda_function.zip"
}
