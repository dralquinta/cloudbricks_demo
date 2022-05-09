#!/bin/sh

terraform init
terraform validate
terraform apply --var-file=system.tfvars --auto-approve

rm -rf .terraform
rm .terraform*