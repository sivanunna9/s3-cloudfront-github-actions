#!/bin/bash
set -e

echo "Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y unzip wget curl

TERRAFORM_VERSION=1.13.4
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v

TOFU_VERSION=1.8.2
wget -q https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_amd64.zip
unzip -o tofu_${TOFU_VERSION}_linux_amd64.zip
sudo mv tofu /usr/local/bin/
tofu version || echo "⚠️ OpenTofu installation failed"

TERRAGRUNT_VERSION=v0.57.3
wget -q https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
sudo chmod +x /usr/local/bin/terragrunt
terragrunt -v
