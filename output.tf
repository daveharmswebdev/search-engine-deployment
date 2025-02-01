# S3 Bucket Outputs
output "s3_bucket_name" {
  description = "The name of the S3 bucket created"
  value       = aws_s3_bucket.pdf_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.pdf_bucket.arn
}

# OpenSearch Domain Outputs
output "opensearch_domain_endpoint" {
  description = "The endpoint of the OpenSearch domain"
  value       = aws_opensearch_domain.open_search_domain.endpoint
}

output "opensearch_domain_arn" {
  description = "The ARN of the OpenSearch domain"
  value       = aws_opensearch_domain.open_search_domain.arn
}

output "opensearch_dashboard_url" {
  description = "The URL to access the OpenSearch Dashboards"
  value       = aws_opensearch_domain.open_search_domain.endpoint
}

output "api_gateway_id" {
  description = "The ID of the created API Gateway"
  value       = aws_apigatewayv2_api.api_gateway.id
}

output "api_gateway_endpoint" {
  description = "The endpoint to invoke the API Gateway"
  value       = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "api_gateway_stage_name" {
  description = "The name of the default API Gateway stage"
  value       = aws_apigatewayv2_stage.api_gateway_stage.name
}

# Output the API Gateway base URL
output "api_gateway_url" {
  description = "The base URL of the API Gateway"
  # Construct the API Gateway base URL dynamically
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}

# Output the Lambda function ARN
output "lambda_search_gateway_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.search_gateway.arn
}

output "lambda_pdf_text_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.pdf_to_text_converter.arn
}

output "lambda_upload_to_search_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.upload_to_search.arn
}

output "lambda_search_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.search_function.arn
}





