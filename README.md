# Infrastructure Deployment & Product Filter 

## Overview
- **Infrastructure Deployment**: Terraform modules (S3, CloudFront) deployed via Terragrunt for example QA environment.
- **Filter & Upload Products**: Python script downloads products from DummyJSON, filters products with price ≥ 100, saves JSON, and uploads to S3 with metadata.  

---

## Pre-requisites
- Python 3.11+  
- AWS account with S3 access  
- Terraform 1.13.+
- Terragrunt 0.57+
- TOFU 1.8+
- GitHub Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`
- Please create the first S3 bucket to store the Terragrunt state, named like **demo-terragrunt-state-bucket**, using the AWS account login. Kindly use the same bucket name for all remote stages, including state storage and locking, to maintain consistency.

---
## Self-hosted server setup

For the self-hosted server setup, please make sure to run the **install_tools.sh** script. This script installs all the required prerequisite tools such as Terraform, OpenTofu, and Terragrunt to ensure the environment is properly configured before proceeding.

## Running Steps
- **Environment/qa/inputs.yaml**: Contains environment-specific input variables used by Terragrunt modules for deployment please modify basd on requirment.

### 1.Deploy Infrastructure
```bash
cd Environment/qa
terragrunt run-all init
terragrunt run-all apply -auto-approve
```

### 2.Filter & Upload Products
**Note:**
Please update the following variables in App-code/filter_and_upload_to_s3.py with the correct values:

```
s3_bucket = "your-s3-bucket-name"
cloudfront_url = "your-cloudfront-url"
```
Set s3_bucket to the name of the S3 bucket created using Terragrunt.
Set cloudfront_url to the corresponding CloudFront distribution URL.

```bash
pip install -r App-code/requirements.txt
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="your-region"
python App-code/filter_and_upload_to_s3.py
```

### GitHub Actions Workflows
- deploy_infra.yml → Deploys infrastructure using Terragrunt
- filter-and-upload.yml → Runs Python script & uploads JSON to S3
- destroy_deploy_infra.yml → Destroy Deploy: This command destroys the infrastructure managed by Terragrunt.
Note: Before running, please ensure that any existing files in the associated S3 bucket are deleted.




