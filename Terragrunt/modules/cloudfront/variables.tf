variable "origin_bucket_id" {
  description = "S3 bucket id to use as origin (bucket resource id)"
  type        = string
}

variable "origin_access_identity_comment" {
  description = "Comment for the origin access identity"
  type        = string
  default     = "cloudfront-oai"
}

variable "comment" {
  description = "Description or comment for the CloudFront distribution"
  type        = string
  default     = "CloudFront distribution created by Terraform"
}

variable "aliases" {
  description = "Alternate domain names for CloudFront"
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
