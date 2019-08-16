##############################################################################
# This file creates the compute instances for the solution.
# Each virtual server is deployed one of the three zones and attached to a subnet.
# The count represents the total number of VSIs and the zones are assigned sequentially.
# The VSIs are assigned ssh keys,  network interface, security group, boot volume 
# and data volume to each vsi 
##############################################################################


# Deploy VSIs, attach volumes, install monitor and loggin agents, assign ssh key
resource "ibm_is_instance" "multizone_is" {
  count   = "${var.vsi_count}"
  name    = "multizone-vsi-${var.unique_id}-${count.index + 1}"
  image   = "${var.image_template_id}"
  profile = "${var.machine_type}"

  provisioner "local-exec" {
    command = "echo ${replace(replace(replace(file("./config/config_logDNA.sh"), "$1", "${ibm_resource_key.multizone_logdna_secret.credentials["ingestion_key"]}"), "$2", "${ibm_resource_key.monitoring_sysdig_secret.credentials["Sysdig Access Key"]}"), "$REGION", "${var.ibm_region}")}"
  }
  primary_network_interface = {
    name            =  "multizone-interface-${count.index + 1}"
    subnet          = "${element(ibm_is_subnet.multizone_subnet.*.id, (count.index % 3))}"
    security_groups = ["${ibm_is_security_group.multizone_security_group.id}"]
  }
  volumes    = ["${element(ibm_is_volume.multizone_data_volume.*.id, (count.index))}"]
  vpc        = "${ibm_is_vpc.multizone_vpc.id}"
  zone       = "${var.ibm_region}-${(count.index % 3) + 1}"
  keys       = ["${ibm_is_ssh_key.multizone_ssh_key.id}"]
  user_data  = "${replace(replace(replace(file("./config/config_logDNA.sh"), "$1", "${ibm_resource_key.multizone_logdna_secret.credentials["ingestion_key"]}"), "$2", "${ibm_resource_key.monitoring_sysdig_secret.credentials["Sysdig Access Key"]}"), "$REGION", "${var.ibm_region}")}"
  depends_on = ["ibm_resource_key.multizone_logdna_secret", "ibm_is_volume.multizone_data_volume"]
}

