##############################################################################
# This file creates the PostgresSQL Database, creates a user with Postgres
# rbac, assign IAM policies



# Create Postgresql database
resource "ibm_resource_instance" "postgresql_resource_instance" {
  name              = "multizone_postgresqldb-${var.unique_id}"
  service           = "databases-for-postgresql"
  plan              = "${var.postgres_plan}"
  location          = "${var.ibm_region}" 
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    service-endpoints = "${var.end_pts}"
    key_protect_key = "${data.null_data_source.key_protect_root_key.outputs["root_key"]}"
  }

  //User can increase timeouts
  timeouts {
    create = "25m"
    update = "15m"
    delete = "15m"
  }
}


# Apply developer access policy to postgresql database
resource "ibm_iam_access_group_policy" "dev_policy_for_postgresql" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  roles = "${split(",", (lookup(var.developer_access, "postgresql")))}"

  resources = [{
    service = "databases-for-postgresql"
    resource_instance_id = "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
  }]
  depends_on = ["null_resource.invite_developer_user"]
}

# Apply manager access policy to postgresql database
resource "ibm_iam_access_group_policy" "mgr_policy_for_postgresql" {
  access_group_id = "${ibm_iam_access_group.manager.id}"
  roles = "${split(",", (lookup(var.manager_access, "postgresql")))}"

  resources = [{
    service = "databases-for-postgresql"
    resource_instance_id = "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
  }]
  depends_on = ["null_resource.invite_manager_user"]
}

# Apply cloud engineer access policy to postgresql database
resource "ibm_iam_access_group_policy" "engineer_policy_for_postgresql" {
  access_group_id = "${ibm_iam_access_group.cloud_engineer.id}"
  roles = "${split(",", (lookup(var.cloud_engineer_access, "postgresql")))}"

  resources = [{
    service = "databases-for-postgresql"
    resource_instance_id = "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
  }]
  depends_on = ["null_resource.invite_engineer_user"]
}
