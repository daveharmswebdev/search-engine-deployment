resource "aws_lambda_function" "pdf_to_text_converter" {
  function_name = "pdf-to-text-converter"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 600
  filename      = "${path.module}/lambda-src/pdf-to-text/pdf-to-text.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-src/pdf-to-text/pdf-to-text.zip")

  environment {
    variables = {
      TARGET_BUCKET = aws_s3_bucket.pdf_bucket.bucket
    }
  }

  tags = {
    Service = "PDFToText"
  }
}

resource "aws_lambda_permission" "allow_s3_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pdf_to_text_converter.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pdf_bucket.arn
}