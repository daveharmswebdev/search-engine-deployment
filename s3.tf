resource "random_string" "bucket_suffix" {
  length  = 12
  upper   = false
  special = false
}

resource "aws_s3_bucket" "pdf_bucket" {
  bucket = "pdf-bucket-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_policy" "pdf_bucket_access_block" {
  bucket = aws_s3_bucket.pdf_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "RequireSecureTransport",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          aws_s3_bucket.pdf_bucket.arn,
          "${aws_s3_bucket.pdf_bucket.arn}/*"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}