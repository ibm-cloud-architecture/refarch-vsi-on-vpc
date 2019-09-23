##############################################################
# IBM Cloud Region
##############################################################

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = ""
}

##############################################################################
# IBM Cloud IAM Token
##############################################################################
variable token {
  description = "IBM IAM Auth Token"
  default = ""
}

##############################################################################
# Resource Group ID
##############################################################################
variable resource_group_id {
  description = "Resource Group ID"
  default = ""
}

##############################################################
# IBM Cloud API Key
##############################################################
variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

##############################################################
# Unique ID
##############################################################
variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

#############################################################
# Account ID for Service Policies
##############################################################

variable account_id {
  description = "Account ID, obtain in UI under manage/account/account settings/ID:"
  default     = ""
}

##############################################################
# Resource Service Endpoints
##############################################################
variable end_points {
  description = "Sets whether the end point for resource instances are public or private"
  default = ""
}

##############################################################
# Key Protect Variables
##############################################################

variable kms_plan {
  description = "the plan to use for provisioning key protect instance"
  default     = ""
}

##############################################################


##############################################################
# COS Variables
##############################################################
variable cos_bucket_name {
  description = "the plan to use for provisioning key protect instance"
  default     = ""
}

variable cos_plan {
  description = "cloud object storage plan"
  default     = ""
}

##############################################################

#############################################################
# PostgresSQL Variables
##############################################################
variable postgres_plan {
  description = "postgresSQL database plan"
  default     = ""
}

##############################################################

##############################################################
# Logging and Monitoring Variables
##############################################################

variable log_role {
  description = "logdna role"
  default     = ""
}

variable logging_plan {
  description = "service plan for LogDNA, Activity Tracker."
  default     = ""
}

variable monitor_plan {
  description = "service plan for Monitoring"
  default     = ""
}

##############################################################


##############################################################
# CMS Variables
##############################################################

variable cms_plan {
  description = "service plan for Monitoring"
  default     = ""
}

##############################################################

##############################################################
# Access Group Variables
##############################################################

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

##############################################################
