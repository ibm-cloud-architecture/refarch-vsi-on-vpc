##############################################################################
# This file creates the VPC, Zones, subnets and public gateway for the VPC
# a separate file sets up the load balancers, listeners, pools and members
##############################################################################



# Create a VPC
resource "ibm_is_vpc" "multizone_vpc" {
  name = "multizone-vpc-${var.unique_id}"
  # classic_access = true //needed for private connection to db/cos/kp - uncomment before running 
  resource_group = "${var.resource_group_id}"
  depends_on = ["null_resource.create_auth_token"]
}


# Create address prefixes for each in zone
resource "ibm_is_vpc_address_prefix" "multizone_prefix" {
  count = "3"
  name  = "multizone-prefix-${count.index + 1}"
  zone  = "${var.ibm_region}-${count.index  + 1}"
  vpc   = "${ibm_is_vpc.multizone_vpc.id}"
  cidr  = "${var.address_prefix_beginning}${count.index + 11}${var.address_prefix_ending}"
}


# Creates the three public subnets, one in each zone using network prefixes 1-3
resource "ibm_is_subnet" "multizone_subnet" {
  count           = "3"
  name            = "multizone-subnet-${var.unique_id}-${count.index + 1}"
  vpc             = "${ibm_is_vpc.multizone_vpc.id}"
  zone            = "${var.ibm_region}-${count.index + 1}"
  ipv4_cidr_block = "${element(ibm_is_vpc_address_prefix.multizone_prefix.*.cidr, count.index)}"
  public_gateway  = "${element(ibm_is_public_gateway.multizone_gateway.*.id, count.index)}"
  network_acl     = "${ibm_is_network_acl.multizone_acl.id}" 
}


# Adds the public gateway for the VPC
resource "ibm_is_public_gateway" "multizone_gateway" {
  count = "3"
  name  = "multizone-gateway-zone-${var.unique_id}-${count.index+1}"
  vpc   = "${ibm_is_vpc.multizone_vpc.id}"
  zone  = "${var.ibm_region}-${count.index+1}"
}


# Apply developer access policy to the VPC.
resource "ibm_iam_access_group_policy" "vpc_developer_access_policy" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  roles           = "${split(",", (lookup(var.developer_access, "vpc")))}"
  resources = [{
    service           = "is"
    resource_group_id = "${var.resource_group_id}"
  }]
  depends_on = ["null_resource.invite_developer_user"]
}


# Apply manager access policy to the VPC  
resource "ibm_iam_access_group_policy" "vpc_manager_access_policy" {
  access_group_id = "${ibm_iam_access_group.manager.id}"
  roles           = "${split(",", (lookup(var.manager_access, "vpc")))}"
  resources = [{
    service           = "is"
    resource_group_id = "${var.resource_group_id}"
  }]
  depends_on = ["null_resource.invite_manager_user"]
}


# Apply cloud engineer access policy to the  VPC  
resource "ibm_iam_access_group_policy" "vpc_cloud_access_policy" {
  access_group_id = "${ibm_iam_access_group.cloud_engineer.id}"
  roles           = "${split(",", (lookup(var.cloud_engineer_access, "vpc")))}"
  resources = [{
    service           = "is"
    resource_group_id = "${var.resource_group_id}"
  }]
  depends_on = ["null_resource.invite_engineer_user"]
}
