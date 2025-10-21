output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "oai_id" {
  description = "ID of the CloudFront Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.oai.id
}
