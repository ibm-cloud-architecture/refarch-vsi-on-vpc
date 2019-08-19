###############################################################
# This file creates as service id and policy for the ID 
##############################################################

 

# Create service ID that can be used by devops tooling
resource "ibm_iam_service_id" "service_id" {
  name        = "multizone-${var.unique_id}-${var.toolchain_service}" 
  description = "Service ID for CI/CD tool chain. Deploys applications to IKS environments"
}


# Apply an access policy to the service ID 
resource "ibm_iam_service_policy" "service_policy" {
  iam_service_id = "${ibm_iam_service_id.service_id.id}"
  roles          = ["Manager", "Administrator"]

  resources = [{
    resource_group_id = "${var.resource_group_id}"
  }]
}
