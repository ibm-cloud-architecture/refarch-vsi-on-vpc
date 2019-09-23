##############################################################################
# This file creates the IBM Certificate manager resource instnace
##############################################################################


##############################################################
# Create certificate manager 
##############################################################

resource "ibm_resource_instance" "multizone_cms" {
  name              = "multizone-cms-${var.unique_id}"
  service           = "cloudcerts"
  plan              = "${var.cms_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    "HMAC"            = true,
    service-endpoints = "${var.end_points}"
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
##############################################################