#!/bin/sh

terraform init
terraform validate
terraform destroy --var-file=system.tfvars --auto-approve

rm -rf .terraform
rm .terraform*