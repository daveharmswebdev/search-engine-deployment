resource "aws_lambda_function" "search_gateway" {
  filename      = "${path.module}/lambda-src/search-gateway/search-gateway.zip"
  function_name = "search-gateway"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.lambdaHandler"
  runtime       = "nodejs20.x"
  timeout       = 15
  memory_size   = 128

  source_code_hash = filebase64sha256("${path.module}/lambda-src/search-gateway/search-gateway.zip")

  tags = {
    Service = "SearchGateway"
  }
}