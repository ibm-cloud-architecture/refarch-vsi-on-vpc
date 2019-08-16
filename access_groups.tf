
###############################################################
# This file creates the three access groups for the roles defined in the architecture 
# and adds users based on a formatted map variable. In the .tf file for each service, 
#a policy is created for each of these access groups.
###############################################################



# Create 3 access groups
resource "ibm_iam_access_group" "developer" {
  name = "devteam"
  tags              = ["multizone"]
}
resource "ibm_iam_access_group" "manager" {
  name = "mgrs"
  tags              = ["multizone"]
}
resource "ibm_iam_access_group" "cloud_engineer" {
  name = "engineer"
  tags              = ["multizone"]
}


# Add members to each group i.e: devteam, mgrs, cloud engineers.
resource "ibm_iam_access_group_members" "developer_access_members" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  ibm_ids         = "${split(",", (lookup(var.developer_access, "user")))}"
}

resource "ibm_iam_access_group_members" "manager_access_members" {
  access_group_id = "${ibm_iam_access_group.manager.id}"
  ibm_ids         = "${split(",", (lookup(var.manager_access, "user")))}"
}
resource "ibm_iam_access_group_members" "engineer_access_members" {
  access_group_id = "${ibm_iam_access_group.cloud_engineer.id}"
  ibm_ids         = "${split(",", (lookup(var.cloud_engineer_access, "user")))}"
}


