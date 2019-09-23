##############################################################################
# This file creates the PostgresSQL Database, creates a user with Postgres
# rbac, assign IAM policies
##############################################################################

##############################################################################
# Create Postgresql database
##############################################################################

resource "ibm_resource_instance" "postgresql_resource_instance" {
  name              = "multizone_postgresqldb-${var.unique_id}"
  service           = "databases-for-postgresql"
  plan              = "${var.postgres_plan}"
  location          = "${var.ibm_region}" 
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    service-endpoints = "${var.end_points}"
    key_protect_key = "${data.null_data_source.key_protect_root_key.outputs["root_key"]}"
  }

  //User can increase timeouts
  timeouts {
    create = "25m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################