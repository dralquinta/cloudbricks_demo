# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# backend.tf
#
# Purpose: Handles the storage of tfstate file in backend bucket


terraform {
  backend "s3" {
    bucket   = "status_bucket"
    key      = "Cloudbricks_Demo/sample.tfstate"
    region   = "us-ashburn-1"
    endpoint = "https://foobarbar.compat.objectstorage.us-ashburn-1.oraclecloud.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}