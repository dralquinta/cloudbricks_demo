#!/bin/sh

rm -rf .terraform
rm .terraform*

terraform init
terraform validate
terraform apply --var-file=system.tfvars --auto-approve

rm -rf .terraform
rm .terraform*