# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

terraform init
terraform validate
terraform apply --var-file=system.tfvars --auto-approve

rm -rf .terraform
rm .terraform*