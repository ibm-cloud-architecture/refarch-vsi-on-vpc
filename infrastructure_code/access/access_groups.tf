
###############################################################
# This file creates the three access groups for the roles defined in the architecture 
# and adds users based on a formatted map variable. In the .tf file for each service, 
#a policy is created for each of these access groups.
###############################################################



##############################################################################
# Create 3 access groups
##############################################################################

resource "ibm_iam_access_group" "developers" {
  name = "developers"
  tags = ["multizone"]
}

resource "ibm_iam_access_group" "managers" {
  name = "managers"
  tags = ["multizone"]
}

resource "ibm_iam_access_group" "engineers" {
  name = "engineers"
  tags = ["multizone"]
}
##############################################################################



##############################################################################
# Add members to each group i.e: developers, managers, engineers.
##############################################################################

resource "ibm_iam_access_group_members" "developer_access_members" {
  access_group_id = "${ibm_iam_access_group.developers.id}"
  ibm_ids         = "${split(",", (lookup(var.developer_access, "user")))}"
}

resource "ibm_iam_access_group_members" "manager_access_members" {
  access_group_id = "${ibm_iam_access_group.managers.id}"
  ibm_ids         = "${split(",", (lookup(var.manager_access, "user")))}"
}
resource "ibm_iam_access_group_members" "engineer_access_members" {
  access_group_id = "${ibm_iam_access_group.engineers.id}"
  ibm_ids         = "${split(",", (lookup(var.engineer_access, "user")))}"
}

##############################################################################

