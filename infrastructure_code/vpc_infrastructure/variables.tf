#############################################################
# Account ID for Service Policies
##############################################################

variable account_id {
  description = "Account ID, obtain in UI under manage/account/account settings/ID:"
  default     = ""
}

##############################################################
# IAM Token
##############################################################
variable ibmcloud_apikey {
  description = "IBM Cloud API Key"
  default     = ""
}




##############################################################
# Unique ID
##############################################################
variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

##############################################################################
# Resource Group ID
##############################################################################
variable resource_group_id {
  description = "Resource Group ID"
  default = ""
}

##############################################################
# IBM Cloud Region
##############################################################

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = ""
}

##############################################################
# VSI Count
##############################################################

variable vsi_count {
  description = "Number of VSI instances to be created"
  default     = ""
}

##############################################################
# VPC Address Prefixes
##############################################################

variable address_prefix_beginning {
  description = "address prefix used in vpc"
  default     = ""
}

variable address_prefix_ending {
  description = "address prefix used in vpc"
  default     = ""
}

##############################################################
# Access to any IP
##############################################################

variable access_to_any_ip {
  description = "Give access to any ip"
  default     = ""
}

##############################################################
# OS image template used while provisioning VM. 
##############################################################

variable image_template_id {
  description = "Image template id used for  VSI"
  default     = ""
}

##############################################################
# Machine type used while provisioning VM.
##############################################################

variable machine_type {
  description = "VSI machine type"
  default     = "cc1-2x4"
}

##############################################################
# Load Balancer Algorithm
##############################################################

variable lb_algorithm {
  description = "Algorithm for load balancing across VSI"
  default = ""
}

##############################################################
# Load Balancer Protocol
##############################################################

variable lb_protocol {
  description = "protocol for load balancing across VSI"
  default = ""
}

##############################################################
# SSH Key
##############################################################

variable ssh_key {
  description = "ssh public key that will be assigned to each VSI. Ensure no extra spaces"
  default     = ""
}

##############################################################
# CMS Resource ID
##############################################################

variable cms_id {
  description = "Algorithm for load balancing across VSI"
  default = ""
}

##############################################################
# LogDNA Variables
##############################################################

variable "log_ingestion_key" {
    description = "LogDNA Ingestion Key"
    default = ""
}

variable "sysdig_access_key" {
    description = "Sysdig access key"
    default = ""
}

##############################################################################
# Access group variables
##############################################################################

variable manager_access {
  description = "List of users and access policies for access_group: manager"
  default = {}
}

variable developer_access {
  description = "List of users and access policies for access_group: developer"
  default = {}
}

variable engineer_access {
  description = "List of users and access policies for access_group: engineers"
  default = {}
}


##############################################################################
# Access group id variables
##############################################################################

variable manager_access_id {
  description = "List of users and access policies for access_group: manager"
  default = ""
}

variable developer_access_id {
  description = "List of users and access policies for access_group: developer"
  default = ""
}

variable engineer_access_id {
  description = "List of users and access policies for access_group: engineers"
  default = ""
}
