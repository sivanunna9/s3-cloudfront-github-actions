terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

terraform {
  backend "s3" {}
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = var.origin_access_identity_comment
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  aliases = var.aliases
  comment = var.comment 

  default_root_object = var.default_root_object

  origin {
    domain_name = "${var.origin_bucket_id}.s3.amazonaws.com"
    origin_id   = "S3-${var.origin_bucket_id}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.oai.id}"
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.origin_bucket_id}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}