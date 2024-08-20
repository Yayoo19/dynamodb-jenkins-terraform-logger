output "dynamodb_table_name" {
  value = aws_dynamodb_table.logs_table.name
}

output "lambda_function_name" {
  value = aws_lambda_function.log_function.function_name
}
