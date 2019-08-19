##############################################################
# This terraform file contains the variables and default values for
# this architecture. Default values will be used unless changed at deployment time.
##############################################################

##############################################################
# Service End Point specific variable  unique ID to assign to
# names of all resources to keep them unique. Default blank
##############################################################
variable unique_id {
  description = "a unique id that could be included in naming of all resources. No caps or _ must be at least one character"
  default = "o"
}
##############################################################
# Service End Point specific variable 
# used to centralize setting private/public
##############################################################
variable end_pts {
  description = "Sets whether the end point for resource instances are public or private"
  default = "private"
}

##############################################################
# Account specific variables
##############################################################

variable classiciaas_apikey {
  description = "The Infrastructure API Key needed to deploy all IaaS resources"
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
  default     = "eu-gb"
}


variable resource_group_id {
  description = "the ID of the resource group to use for all depoying resource instances and policies. access via CLI ibmcloud resource groups"
  default     = ""
}

##############################################################
# IAM specific variables
# Includes users by roles and access group policy assignment by service
##############################################################

variable manager_access {
  description = "List of users and access policies for access_group: manager"
  default = {
    "user"         = "mgr1@us.ibm.com,mgr2@us.ibm.com", // no space between 2 users.
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
    "user"         = "dev1@us.ibm.com,dev2@us.ibm.com", // no space between 2 users.
    "postgresql"   = "Administrator",
    "cos"          = "Writer",
    "kms"          = "Writer",
    "cms"          = "Writer",
    "vpc"          = "Editor",
    "bucket"       = "Manager"
    "account_role" = "Developer"
  }
}

variable cloud_engineer_access {
  description = "List of users and access policies for access_group: cloud_engineer"
  default = {
    "user"         = "eng1@us.ibm.com,eng2@us.ibm.com", // no space between 2 users.
    "postgresql"   = "Viewer",
    "cos"          = "Writer",
    "kms"          = "Writer",
    "cms"          = "Writer",
    "vpc"          = "Editor",
    "account_role" = "Developer"
  }
}

##############################################################
# VPC specific variables
# See this page for guidance on IP management
# https://cloud.ibm.com/docs/vpc?topic=vpc-choosing-ip-ranges-for-your-vpc&locale=en-us
##############################################################
variable address_prefix_beginning {
  description = "address prefix used in vpc"
  default     = "10.10."
}

variable address_prefix_ending {
  description = "address prefix used in vpc"
  default     = ".0/24"
}

variable "zones" {
  description = "zones"
  default = {
    "0" = "zone1"
    "1" = "zone2"
    "2" = "zone3"
    "3" = "dev-db"
    "4" = "test-db"
    "5" = "admin-db"
  }
}

# CIDR value for subnet.
variable subnet_cidr {
  description = "Used for creating subnets in each zones using the given cidr"
  default     = "10.16.0.0/25"
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
# Security Group specific variables
##############################################################
variable access_to_any_ip {
  description = "Give access to any ip"
  default     = "0.0.0.0/0"
}
variable security_group_port {
  description = "Used for adding rule for security group"
  default     = 3389
}



##############################################################
# Key Protect specific variables
##############################################################
variable kms_plan {
  description = "the plan to use for provisioning key protect instance"
  default     = "tiered-pricing"
}

##############################################################
# VSI specific variables
##############################################################
variable vsi_count {
  description = "number of vsi that will be deployed across the regions and subnets"
  default     = "6"
}

# OS image template used while provisioning VM. Default image is of Ubuntu.
variable image_template_id {
  description = "Image template id used for VM. `ubuntu 18.04`"
  default     = "cfdaf1a0-5350-4350-fcbc-97173b510843"
}

# Machine type used while provisioning VM.
variable machine_type {
  description = "VM machine type"
  default     = "cc1-2x4"
}


##############################################################
# ACL specific variables
##############################################################

variable ACLsource_ingress {
  description = "Used for creating ACL source ingress cidr"
  default     = "0.0.0.0/0"
}
variable ACLdest_ingress {
  description = "Used for creating ACL destination ingress cidr"
  default     = "0.0.0.0/0"
}

variable ACLsource_egress {
  description = "Used for creating ACL source egress cidr"
  default     = "0.0.0.0/0"
}

variable ACLdest_egress {
  description = "Used for creating ACL destination egress cidr"
  default     = "0.0.0.0/0"
}

variable tcp_max_port {
  description = "The highest port in the range of ports to be matched"
  default     = 65535
}

variable tcp_min_port {
  description = "The highest port in the range of ports to be matched"
  default     = 1
}


##############################################################
# ICOS specific variables
##############################################################
variable cos_bucket_name {
  description = "Name used for cos bucket, it needs to be unique name among all buckets"
  default     = "cos-bucket-5"
}

variable cos_plan {
  description = "cloud object storage plan"
  default     = "standard"
}

#############################################################
# PostgresSQL specific variables
##############################################################
variable postgres_plan {
  description = "postgresSQL database plan"
  default     = "standard"
}

#############################################################
# Certificate manager specific variables
##############################################################

variable cms_plan {
  description = "certificate manager plan"
  default     = "free"
}


##############################################################
# Logging and Monitoring specific variables
##############################################################
variable log_role {
  description = "logdna role"
  default     = "Manager"
}

variable logging_plan {
  description = "service plan for LogDNA, Activity Tracker."
  default     = "7-day"
}

variable monitor_plan {
  description = "service plan for Monitoring"
  default     = "graduated-tier"
}


##############################################################
# DevOps toolchain specific variable
##############################################################
variable toolchain_service {
  description = "Service name for service id"
  default     = "toolchain_service"
}
