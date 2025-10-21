terraform {
  source = "../../../modules/cloudfront"
}

include {
  path = find_in_parent_folders("root.hcl")
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "kishore-terragrunt-state-bucket"
    key     = "cloudfront/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  input_vars = yamldecode(file("${get_terragrunt_dir()}/../inputs.yaml"))
}

inputs = {
  origin_bucket_id               = local.input_vars.origin_bucket_id
  aliases                        = local.input_vars.aliases
  default_root_object            = local.input_vars.default_root_object
  tags                           = local.input_vars.tags
  comment                        = local.input_vars.comment
  origin_access_identity_comment = local.input_vars.origin_access_identity_comment
}
