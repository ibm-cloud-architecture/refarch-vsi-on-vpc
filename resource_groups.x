##############################################################################
# This file creates  Resource Group using an input name 
# then references the ID in other blocks
##############################################################################



# Extract resource_group ID using the name in the variable 
data "ibm_resource_group" "resource_group" {
  name = "${var.resource_group}"
}

data "null_data_source" "resource_group" {
  inputs = {
    resource_id = "${data.ibm_resource_group.resource_group.id}" // ibm_resource_group.resource_group.id
  }
}
