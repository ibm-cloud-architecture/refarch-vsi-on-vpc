##############################################################################
# Provider block
##############################################################################

provider "ibm" {
    ibmcloud_api_key   = "${var.ibmcloud_apikey}"
    softlayer_username = "${var.classiciaas_username}"
    softlayer_api_key  = "${var.classiciaas_apikey}"
    region             = "${var.ibm_region}"
    generation         = 1
    ibmcloud_timeout   = 60
}

##############################################################################


##############################################################################
# Create Access Policies and User Management
##############################################################################

module "user_access_policies" {
    source              = "./access"
    account_id          = "${var.account_id}"
    toolchain_service   = "${var.toolchain_service}"
    ibmcloud_apikey     = "${var.ibmcloud_apikey}"
    manager_access      = "${var.manager_access}"
    developer_access    = "${var.developer_access}"
    engineer_access     = "${var.engineer_access}"
    unique_id           = "${var.unique_id}"
    resource_group_id   = "${var.resource_group_id}"
}

##############################################################################


##############################################################################
# Create KMS, COS, CMS, PSQL, and LogDNA
##############################################################################

module "cloud_resources" {
    source              = "./resources" 
    
    # Account Variables
    account_id          = "${var.account_id}"
    ibm_region          = "${var.ibm_region}"
    ibmcloud_apikey     = "${var.ibmcloud_apikey}"
    resource_group_id   = "${var.resource_group_id}"
    unique_id           = "${var.unique_id}"

    # Resource Variables
    end_points          = "${var.end_points}"
    kms_plan            = "${var.kms_plan}"
    cos_plan            = "${var.cos_plan}"
    cos_bucket_name     = "${var.cos_bucket_name}"
    cos_plan            = "${var.cos_plan}"
    cms_plan            = "${var.cms_plan}"
    postgres_plan       = "${var.postgres_plan}"
    log_role            = "${var.log_role}"
    logging_plan        = "${var.logging_plan}"
    monitor_plan        = "${var.monitor_plan}"

    # Access Variables
    manager_access      = "${var.manager_access}"
    developer_access    = "${var.developer_access}"
    engineer_access     = "${var.engineer_access}"
    manager_access_id   = "${module.user_access_policies.managers_group_id}"
    developer_access_id = "${module.user_access_policies.developers_group_id}"
    engineer_access_id  = "${module.user_access_policies.engineers_group_id}"
}

##############################################################################


##############################################################################
# Create VPC Infrastructure
##############################################################################

module "vpc_infrastructure" {
    source                   = "./vpc_infrastructure" 

    # Account Variables
    resource_group_id        = "${var.resource_group_id}"
    account_id               = "${var.account_id}"
    unique_id                = "${var.unique_id}"  
    ibm_region               = "${var.ibm_region}"
    ibmcloud_apikey          = "${var.ibmcloud_apikey}"

    # Networking Variables
    address_prefix_beginning = "${var.address_prefix_beginning}"
    address_prefix_ending    = "${var.address_prefix_ending}"
    access_to_any_ip         = "${var.access_to_any_ip}"
    lb_protocol              = "${var.lb_protocol}"
    lb_algorithm             = "${var.lb_algorithm}"

    # VSI Variables
    vsi_count                = "${var.vsi_count}"
    image_template_id        = "${var.image_template_id}"
    machine_type             = "${var.machine_type}"
    ssh_key                  = "${var.ssh_key}"
    log_ingestion_key        = "${module.cloud_resources.log_ingestion_key}"
    sysdig_access_key        = "${module.cloud_resources.sysdig_access_key}"

    # Access Variables
    cms_id                   = "${module.cloud_resources.cms_id}"
    manager_access           = "${var.manager_access}"
    developer_access         = "${var.developer_access}"
    engineer_access          = "${var.engineer_access}"
    manager_access_id        = "${module.user_access_policies.managers_group_id}"
    developer_access_id      = "${module.user_access_policies.developers_group_id}"
    engineer_access_id       = "${module.user_access_policies.engineers_group_id}"
}

##############################################################################
