variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy objects when deleting the bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "oai_id" {
  description = "CloudFront Origin Access Identity ID"
  type        = string
  default     = ""
}
