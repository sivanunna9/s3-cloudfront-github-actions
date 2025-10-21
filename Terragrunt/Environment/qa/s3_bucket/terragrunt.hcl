terraform {
  source = "../../../modules/s3"
}

include {
  path = find_in_parent_folders("root.hcl")
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "kishore-terragrunt-state-bucket"
    key     = "s3_bucket/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

dependency "cloudfront" {
  config_path = "../cloudfront"

  # optional: used if CloudFront not applied yet
  mock_outputs = {
    oai_id = "MOCK_OAI_ID"
  }
}

locals {
  input_vars = yamldecode(file("${get_terragrunt_dir()}/../inputs.yaml"))
}

inputs = {
  bucket_name   = local.input_vars.origin_bucket_id
  force_destroy = local.input_vars.force_destroy
  oai_id        = dependency.cloudfront.outputs.oai_id
  tags          = local.input_vars.tags
}
