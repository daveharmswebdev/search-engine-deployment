resource "aws_s3_bucket_notification" "s3_event_notification" {
  bucket = aws_s3_bucket.pdf_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.pdf_to_text_converter.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".pdf"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.upload_to_search.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }
}