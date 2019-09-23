##############################################################################
# This file creates the monitoring resource instance
##############################################################################


##############################################################################
# Create monitoring with sysdig instance
##############################################################################

resource "ibm_resource_instance" "multizone_monitoring_sysdig" {
  name              = "multizone_monitor-${var.unique_id}"
  location          = "${var.ibm_region}"
  service           = "sysdig-monitor"
  plan              = "${var.monitor_plan}"
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]
}

##############################################################################


##############################################################################
# Create monitoring with Sysdig instance access key
##############################################################################

resource "ibm_resource_key" "monitoring_sysdig_secret" {
  name                 = "multizone_monitor-key-${var.unique_id}"
  role                 = "${var.log_role}"
  resource_instance_id = "${ibm_resource_instance.multizone_monitoring_sysdig.id}"
  depends_on           = ["ibm_resource_instance.multizone_monitoring_sysdig"]
}

##############################################################################