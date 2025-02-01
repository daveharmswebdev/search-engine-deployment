resource "aws_lambda_function" "upload_to_search" {
  function_name = "upload-to-search"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 600
  filename      = "${path.module}/lambda-src/upload-to-search/upload-to-search.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-src/upload-to-search/upload-to-search.zip")

  environment {
    variables = {
      REGION                   = data.aws_region.current.name
      OPENSEARCH_DASHBOARD_URL = "https://${aws_opensearch_domain.open_search_domain.endpoint}"
      OPENSEARCH_INDEX         = var.opensearch_index
      OPENSEARCH_USERNAME      = var.master_user_name
      OPENSEARCH_PASSWORD      = var.master_user_password
    }
  }

  tags = {
    Service = "UploadToSearch"
  }
}

resource "aws_lambda_permission" "allow_s3_invoke_upload_to_search" {
  statement_id  = "AllowS3InvokeUploadToSearch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_to_search.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pdf_bucket.arn
}