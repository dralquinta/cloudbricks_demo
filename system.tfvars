# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# system.tfvars
#
# Purpose: The following script defines the system particular variables to provision environment

########## PROVIDER SPECIFIC VARIABLES ##########
region           = "us-ashburn-1"
tenancy_ocid     = "ocid1.tenancy.oc1..foo"
user_ocid        = "ocid1.user.oc1..bar"
fingerprint      = "11:32:1bar:bar:bar:bar:foo:foo:foo72:70"
private_key_path = "/home/opc/.ssh/OCI_KEYS/API/auto_api_key.pem"
########## PROVIDER SPECIFIC VARIABLES ##########

########## INSTANCE SPECIFIC VARIABLES ##########
instance01_ssh_public_key                   = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa.pub"
instance01_ssh_private_key                  = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa"
instance01_ssh_public_is_path               = true
instance01_ssh_private_is_path              = true
instance01_compute_availability_domain_list = ["xyzq:US-ASHBURN-AD-2"]

instance01_network_subnet_name                     = "Public Subnet-VCN"
instance01_assign_public_ip_flag                   = true
instance01_fault_domain_name                       = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]
instance01_bkp_policy_boot_volume                  = "bronze"
instance01_linux_compute_instance_compartment_name = "CloudbricksDemo"
instance01_linux_compute_network_compartment_name  = "CloudbricksDemo"
instance01_vcn_display_name                        = "VCN"
instance01_num_instances                           = 1
instance01_is_nsg_required                         = false
instance01_compute_nsg_name                        = ""
instance01_compute_display_name_base               = "demoubuntu"
instance01_instance_image_ocid                     = "ocid1.image.oc1.iad.aaaaaaaamc2xy64p4r4tcwjy26ksdkehrdrzjcacw4upaq7fnqict55as4kq"
instance01_instance_shape                          = "VM.Standard3.Flex"
instance01_is_flex_shape                           = true
instance01_instance_shape_config_ocpus             = 1
instance01_instance_shape_config_memory_in_gbs     = 16

########## INSTANCE SPECIFIC VARIABLES ##########

########## ARTIFACT SPECIFIC VARIABLES ##########
fssdisk01_num_of_fss                           = 1
fssdisk01_export_path_base                     = "fss"
fssdisk01_fss_display_name_base                = "fssdisk"
fssdisk01_fss_instance_compartment_name        = "CloudbricksDemo"
fssdisk01_fss_network_compartment_name         = "CloudbricksDemo"
fssdisk01_mt_compartment_name                  = "CloudbricksDemo"
fssdisk01_vcn_display_name                     = "VCN"
fssdisk01_network_subnet_name                  = "Public Subnet-VCN"
fssdisk01_fss_mount_target_availability_domain = "xyzq:US-ASHBURN-AD-2"
fssdisk01_fss_mount_target_name                = "demo_mt"
fssdisk01_os_type                              = "ubuntu"
fssdisk01_ssh_private_key                      = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa"
########## ARTIFACT SPECIFIC VARIABLES ##########

########## ARTIFACT SPECIFIC VARIABLES ##########
asciiart01_ssh_public_key      = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa.pub"
asciiart01_ssh_private_key     = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa"
asciiart01_ssh_public_is_path  = true
asciiart01_ssh_private_is_path = true
asciiart01_script_name         = "./scripts/ascii_art.sh"
asciiart01_script_args         = "DENNY 120"
asciiart01_exec_user           = "ubuntu"
########## ARTIFACT SPECIFIC VARIABLES ##########