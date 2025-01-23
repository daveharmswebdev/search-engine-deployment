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