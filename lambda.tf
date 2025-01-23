resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name = "lambda-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ],
        Resource = [
          aws_s3_bucket.pdf_bucket.arn,
          "${aws_s3_bucket.pdf_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_s3_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_lambda_function" "pdf_to_text_converter" {
  function_name = "pdf-to-text-converter"
  runtime       = "python3.9"
  handler       = "app.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 600
  filename      = "lambda_functions/pdf_to_text.zip"

  environment {
    variables = {
      TARGET_BUCKET = aws_s3_bucket.pdf_bucket.bucket
    }
  }
}

resource "aws_s3_bucket_notification" "s3_event_notification" {
  bucket = aws_s3_bucket.pdf_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.pdf_to_text_converter.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".pdf"
  }
}

resource "aws_lambda_permission" "allow_s3_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pdf_to_text_converter.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pdf_bucket.arn
}