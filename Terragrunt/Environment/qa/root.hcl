remote_state {
  backend = "s3"
  config = {
    bucket  = "kishore-terragrunt-state-bucket"
    key     = "global/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
