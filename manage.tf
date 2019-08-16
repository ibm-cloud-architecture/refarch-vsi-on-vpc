##############################################################################
# This file creates the monitoring, logDNA and activity tracker resource
# instances. Private service end points created if supported.
# Secret keys and agents installed on VSI for montioring and logging.
##############################################################################



# Create monitoring with sysdig instance
resource "ibm_resource_instance" "multizone_monitoring_sysdig" {
  name              = "multizone_monitor-${var.unique_id}"
  location          = "${var.ibm_region}"
  service           = "sysdig-monitor"
  plan              = "${var.monitor_plan}"
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]
}

# Create monitoring with Sysdig instance access key
resource "ibm_resource_key" "monitoring_sysdig_secret" {
  name                 = "multizone_monitor-key-${var.unique_id}"
  role                 = "${var.log_role}"
  resource_instance_id = "${ibm_resource_instance.multizone_monitoring_sysdig.id}"
  depends_on           = ["ibm_resource_instance.multizone_monitoring_sysdig"]
}


# create LogDNA instance
resource "ibm_resource_instance" "multizone_logdna" {
  name              = "multizone_logdna-${var.unique_id}"
  service           = "logdna"
  plan              = "${var.logging_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]
  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

# Create logAnalysis instance access key
resource "ibm_resource_key" "multizone_logdna_secret" {
  name                 = "multzone_logdna-key-${var.unique_id}"
  role                 = "${var.log_role}"
  resource_instance_id = "${ibm_resource_instance.multizone_logdna.id}"
  depends_on           = ["ibm_resource_instance.multizone_logdna"]
}


# Create Activity Tracker with LogDNA instance
resource "ibm_resource_instance" "multizone_activity_tracker" {
  name              = "multizone_activity-tracker-${var.unique_id}"
  service           = "logdnaat"
  plan              = "${var.logging_plan}"
  location          = "${var.ibm_region}"
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    service-endpoints = "${var.end_pts}"
  }
  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}