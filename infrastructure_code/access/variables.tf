#############################################################
# Account ID for Service Policies
##############################################################

variable account_id {
  description = "Account ID, obtain in UI under manage/account/account settings/ID:"
  default     = ""
}

##############################################################


##############################################################
# IBM Cloud API Key
##############################################################

variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

##############################################################


##############################################################
# Service ID Variables
##############################################################

variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = ""
}

variable resource_group_id {
  description = "Resource Group ID"
  default = ""
}

variable toolchain_service {
  description = "Service name for service id"
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

##############################################################