resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.oai_id}"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}
