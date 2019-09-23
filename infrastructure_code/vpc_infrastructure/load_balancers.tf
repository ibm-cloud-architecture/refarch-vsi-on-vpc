##############################################################################
# This file creates the  load balancer for the VSIs deployed to three subnets
##############################################################################


##############################################################################
# Creates three load balancers
##############################################################################

resource "ibm_is_lb" "multizone_lb" {
  count          = "3"
  name           = "multizone-lb-zone-${var.unique_id}-${count.index + 1}"
  type           = "public"
  subnets        = ["${ibm_is_subnet.multizone_subnet.*.id}"]
  resource_group = "${var.resource_group_id}" 
}

##############################################################################


##############################################################################
# Creates a back end pool for the load balancer that includes all VSIs from all zones
##############################################################################

resource "ibm_is_lb_pool" "multizone_pool" {
  count          =  "3"
  name           = "multizone-lb-pool-${var.unique_id}-zone-${count.index + 1}"
  lb             = "${element(ibm_is_lb.multizone_lb.*.id, count.index)}"
  algorithm      = "${var.lb_algorithm}"
  protocol       = "${var.lb_protocol}"
  health_delay   = 20
  health_retries = 3
  health_timeout = 5
  health_type    = "http"
}

##############################################################################


##############################################################################
# Creates a listener for the load balancer to route to VSI 
##############################################################################

resource "ibm_is_lb_listener" "multizone_lb_listener" {
  count        = "3"
  lb           = "${element(ibm_is_lb.multizone_lb.*.id, count.index)}"
  port         = 80
  protocol     = "${var.lb_protocol}"
  default_pool = "${element(ibm_is_lb_pool.multizone_pool.*.id, count.index)}"
  depends_on   = ["ibm_is_lb.multizone_lb"]
}

##############################################################################


##############################################################################
# Creates a pool member for each of the VSIs
##############################################################################
/*
resource "ibm_is_lb_pool_member" "multizone_lb_pool_member" {
  count          = "${var.vsi_count}"
  lb             = "${element(ibm_is_lb.multizone_lb.*.id, count.index)}"
  pool           = "${element(ibm_is_lb_pool.multizone_pool.*.id, count.index % 3)}"
  port           = 80
  target_address = "${element(ibm_is_instance.multizone_is.*.primary_network_interface.0.primary_ipv4_address, count.index)}"
  weight         = 50
  depends_on     = ["ibm_is_lb.multizone_lb"]
}
*/
##############################################################################