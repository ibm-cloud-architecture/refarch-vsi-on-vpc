##############################################################################
# Create block storage (data) volumes that will be attached to VSIs
##############################################################################

resource "ibm_is_volume" "multizone_data_volume" {
  count          = "${var.vsi_count}"
  name           = "multizone-datavol-${var.unique_id}-${count.index + 1}"
  profile        = "10iops-tier"
  zone           = "${var.ibm_region}-${(count.index % 3) + 1}"
  capacity       = 50
  resource_group = "${var.resource_group_id}"
}


##############################################################################