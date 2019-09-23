##############################################################################
# VPC IS Access Policies
##############################################################################

resource "ibm_iam_access_group_policy" "is_developer_access_policy" {
  access_group_id = "${var.developer_access_id}"
  roles           = "${split(",", (lookup(var.developer_access, "vpc")))}"

  resources = [{
    service           = "is"
    resource_group_id = "${var.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "is_manager_access_policy" {
  access_group_id = "${var.manager_access_id}"
  roles           = "${split(",", (lookup(var.manager_access, "vpc")))}"

  resources = [{
    service           = "is"
    resource_group_id = "${var.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "is_engineer_access_policy" {
  access_group_id = "${var.engineer_access_id}"
  roles           = "${split(",", (lookup(var.engineer_access, "vpc")))}"

  resources = [{
    service           = "is"
    resource_group_id = "${var.resource_group_id}"
  }]
}

##############################################################################