output "lambda_arn" {
  value = aws_lambda_function.trigger_function.arn
}

output "lambda_permission_depends_on" {
  value = aws_lambda_permission.allow_s3.id
}
output "lambda_function_name" {
  value = aws_lambda_function.trigger_function.function_name
}