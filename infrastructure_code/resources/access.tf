##############################################################################
# Key Protect Access Policies
##############################################################################

resource "ibm_iam_access_group_policy" "kms_developer_access_policy" {
  access_group_id = "${var.developer_access_id}"
  roles           = "${split(",", (lookup(var.developer_access, "kms")))}"

  resources = [{
    service              = "kms"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
  }]
}

resource "ibm_iam_access_group_policy" "kms_manager_access_policy" {
  access_group_id = "${var.manager_access_id}"
  roles           = "${split(",", (lookup(var.manager_access, "kms")))}"

  resources = [{
    service              = "kms"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
  }] 
}

resource "ibm_iam_access_group_policy" "kms_engineer_access_policy" {
  access_group_id = "${var.engineer_access_id}"
  roles           = "${split(",", (lookup(var.engineer_access, "kms")))}"

  resources = [{
    service              = "kms"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
  }] 
}

##############################################################################


##############################################################################
# Postgres Access Policies
##############################################################################

resource "ibm_iam_access_group_policy" "dev_policy_for_postgresql" {
  access_group_id = "${var.developer_access_id}"
  roles = "${split(",", (lookup(var.developer_access, "postgresql")))}"

  resources = [{
    service = "databases-for-postgresql"
    resource_instance_id = "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
  }]
}

resource "ibm_iam_access_group_policy" "mgr_policy_for_postgresql" {
  access_group_id = "${var.manager_access_id}"
  roles = "${split(",", (lookup(var.manager_access, "postgresql")))}"

  resources = [{
    service = "databases-for-postgresql"
    resource_instance_id = "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
  }]
}

resource "ibm_iam_access_group_policy" "engineer_policy_for_postgresql" {
  access_group_id = "${var.engineer_access_id}"
  roles = "${split(",", (lookup(var.engineer_access, "postgresql")))}"

  resources = [{
    service = "databases-for-postgresql"
    resource_instance_id = "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
  }]
}


##############################################################################


##############################################################################
# COS Access Policies
##############################################################################

resource "ibm_iam_access_group_policy" "cos_developer_access_policy" {
  access_group_id = "${var.developer_access_id}"
  roles = "${split(",", (lookup(var.developer_access, "cos")))}"

  resources = [{
    service = "cloud-object-storage"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
  }]
}


resource "ibm_iam_access_group_policy" "cos_manager_access_policy" {
  access_group_id = "${var.manager_access_id}"
  roles = "${split(",", (lookup(var.manager_access, "cos")))}"

  resources = [{
    service = "cloud-object-storage"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
  }]
}


resource "ibm_iam_access_group_policy" "cos_engineers_access_policy" {
  access_group_id = "${var.engineer_access_id}"
  roles = "${split(",", (lookup(var.engineer_access, "cos")))}"

  resources = [
    {
      service = "cloud-object-storage"
      resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
  }]  
}

##############################################################################


##############################################################################
# CMS Access Policies
##############################################################################

resource "ibm_iam_access_group_policy" "cms_developer_access_policy" {
  access_group_id = "${var.developer_access_id}"
  roles = "${split(",", (lookup(var.developer_access, "cms")))}"

  resources = [{
    service = "cloudcerts"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
  }]
}


resource "ibm_iam_access_group_policy" "cms_manager_access_policy" {
  access_group_id = "${var.manager_access_id}"
  roles = "${split(",", (lookup(var.manager_access, "cms")))}"

  resources = [{
    service = "cloudcerts"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
  }]
}


resource "ibm_iam_access_group_policy" "cms_engineers_access_policy" {
  access_group_id = "${var.engineer_access_id}"
  roles = "${split(",", (lookup(var.engineer_access, "cms")))}"

  resources = [
    {
      service = "cloudcerts"
      resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
  }]  
}

##############################################################################


##############################################################################
# Apply developer access policy to ICOS bucket
##############################################################################

resource "ibm_iam_access_group_policy" "bucket_developer_access_policy" {
  access_group_id = "${var.developer_access_id}"
  roles = "${split(",", (lookup(var.developer_access, "cos")))}"

  resources = [
    {
      service = "cloud-object-storage"
      resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
      resource_type = "bucket"
      resource = "${var.cos_bucket_name}"
  }]

  depends_on = ["null_resource.create_cos_bucket"]
}

##############################################################################