##############################################################################
# This file creates a set of security resources used to control access to
# the VPC networks and VSIs. These include SSH key, security group/rule, ACL.
##############################################################################


##############################################################################
# Creates a security group to be used for each VSI in the VPC
##############################################################################

resource "ibm_is_security_group" "multizone_security_group" {
  name  = "multizone_sg-${var.unique_id}"
  vpc   = "${ibm_is_vpc.multizone_vpc.id}"
}

##############################################################################


##############################################################################
# Creates security group rules in the security group
##############################################################################

resource "ibm_is_security_group_rule" "security_group_rule_ingress" {
  group     = "${ibm_is_security_group.multizone_security_group.id}"
  direction = "ingress"
  remote    = "${var.access_to_any_ip}"
}
resource "ibm_is_security_group_rule" "security_group_rule_egress" {
  group     = "${ibm_is_security_group.multizone_security_group.id}"
  direction = "egress"
  remote    = "${var.access_to_any_ip}"
}

##############################################################################


##############################################################################
# Create an  ACL for ingress/egress used by  all subnets in VPC
##############################################################################

resource "ibm_is_network_acl" "multizone_acl" {
  name = "multizone-acl-${var.unique_id}-${ibm_is_vpc.multizone_vpc.id}"
  rules = [
    {
      name   = "egress"
      action = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "egress"
    },
    {
      name   = "ingress"
      action = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "ingress"
    }
  ]
}

##############################################################################