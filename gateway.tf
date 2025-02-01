resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "search-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gateway_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "search_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.search_gateway.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_search_function" {
  statement_id  = "AllowAPIGatewayInvokeSearchFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.search_function.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_integration" "search_gateway_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.search_gateway.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "search_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.search_gateway_integration.id}"
}

resource "aws_apigatewayv2_integration" "search_function_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.search_function.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "search_route_post" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /search"
  target    = "integrations/${aws_apigatewayv2_integration.search_function_integration.id}"
}