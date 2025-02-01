resource "aws_lambda_function" "search_function" {
  function_name = "search-function"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 600
  filename      = "${path.module}/lambda-src/search-function/search-function.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-src/search-function/search-function.zip")

  environment {
    variables = {
      REGION              = data.aws_region.current.name
      OPENSEARCH_HOST     = "https://${aws_opensearch_domain.open_search_domain.endpoint}"
      OPENSEARCH_INDEX    = var.opensearch_index
      OPENSEARCH_USERNAME = var.master_user_name
      OPENSEARCH_PASSWORD = var.master_user_password
    }
  }

  tags = {
    Service = "SearchFunction"
  }
}