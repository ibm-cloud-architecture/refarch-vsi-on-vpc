##############################################################
# This terraform file contains the variables and default values for
# this architecture. Default values will be used unless changed at deployment time.
##############################################################


##############################################################
# Account Variables
##############################################################

variable unique_id {
  description = "Unique ID included in naming of all resources. No caps or _  and must be at least one character"
  default = ""
}

variable classiciaas_apikey {
  description = "The infrastructure API Key needed to deploy any classic infrastructure resources"
  default     = ""
}

variable classiciaas_username {
  description = "The IBM Cloud classic infrastructure username (email)"
  default     = ""
}

variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

variable account_id {
  description = "Account ID, obtain in UI under manage/account/account settings/ID:"
  default     = ""
}

variable ssh_key {
  description = "ssh public key that will be assigned to each VSI. Ensure no extra spaces"
  default     = ""
}

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = ""
}

variable resource_group_id {
  description = "the ID of the resource group to use for all depoying resource instances and policies"
  default     = ""
}

##############################################################


##############################################################
# Resource Variables
##############################################################
variable end_points {
  description = "Sets whether the end point for resource instances are public or private"
  default = "private"
}


variable kms_plan {
  description = "the plan to use for provisioning Key Protect instance"
  default     = "tiered-pricing"
}

variable cos_bucket_name {
  description = "Name used for IBM COS bucket, it needs to be unique name among all buckets"
  default     = "cos-bucket"
}

variable cos_plan {
  description = "IBM Cloud object storage plan"
  default     = "standard"
}

variable postgres_plan {
  description = "PostgresSQL database plan"
  default     = "standard"
}

variable cms_plan {
  description = "Certificate Manager plan"
  default     = "free"
}

variable log_role {
  description = "LogDNA role"
  default     = "Manager"
}

variable logging_plan {
  description = "Service plan for LogDNA, Activity Tracker."
  default     = "7-day"
}

variable monitor_plan {
  description = "Service plan for Monitoring"
  default     = "graduated-tier"
}

##############################################################


##############################################################################
# Access Group Variables
##############################################################################

variable manager_access {
  description = "List of users and access policies for access_group: manager"
  default = {
    "user"         = "mgr1@ibm.com,mgr2@ibm.com", // no space between 2 users.
    "postgresql"   = "Viewer",
    "cos"          = "Manager",
    "kms"          = "Manager",
    "cms"          = "Manager",
    "vpc"          = "Administrator",
    "account_role" = "Developer"
  }
}

variable developer_access {
  description = "List of users and access policies for access_group: developer"
  default = {
    "user"         = "dev1@ibm.com,dev2@ibm.com", // no space between 2 users.
    "postgresql"   = "Administrator",
    "cos"          = "Writer",
    "kms"          = "Writer",
    "cms"          = "Writer",
    "vpc"          = "Editor",
    "bucket"       = "Manager"
    "account_role" = "Developer"
  }
}

variable engineer_access {
  description = "List of users and access policies for access_group: engineers"
  default = {
    "user"         = "eng1@ibm.com,eng2@ibm.com", // no space between 2 users.
    "postgresql"   = "Viewer",
    "cos"          = "Writer",
    "kms"          = "Writer",
    "cms"          = "Writer",
    "vpc"          = "Editor",
    "account_role" = "Developer"
  }
}
##############################################################################

##############################################################
# VPC specific variabless
# See this page for guidance on IP management
# https://cloud.ibm.com/docs/vpc?topic=vpc-choosing-ip-ranges-for-your-vpc
##############################################################
variable address_prefix_beginning {
  description = "address prefix used in vpc"
  default     = "10.10."
}

variable address_prefix_ending {
  description = "address prefix used in vpc"
  default     = ".0/24"
}

variable lb_algorithm {
  description = "Algorithm for load balancing across VSI"
  default = "round_robin"
}

variable lb_protocol {
  description = "protocol for load balancing across VSI"
  default = "http"
}

##############################################################


##############################################################
# Security Group specific variables
##############################################################

variable access_to_any_ip {
  description = "Give access to any ip"
  default     = "0.0.0.0/0"
}

##############################################################


##############################################################
# VSI specific variables
##############################################################
variable vsi_count {
  description = "number of VSI that will be deployed across the regions and subnets"
  default     = "6"
}
variable image_template_id {
  description = "Image template id used for VSI."
  default     = ""
}
variable machine_type {
  description = "VSI machine type"
  default     = ""
}

##############################################################


##############################################################
# DevOps toolchain specific variable
##############################################################

variable toolchain_service {
  description = "Service name for service id"
  default     = "toolchain_service"
}

##############################################################
