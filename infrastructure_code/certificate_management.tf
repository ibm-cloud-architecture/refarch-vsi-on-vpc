##############################################################################
# This file creates the IBM Certificate manager resource instnace, adds
# IAM policy for the three access groups and authorizes LBaaS to read certs.
##############################################################################


# Create certificate manager 
resource "ibm_resource_instance" "multizone_cms" {
  name              = "multizone-cms-${var.unique_id}"
  service           = "cloudcerts"
  plan              = "${var.cms_plan}"
  location          = "${var.ibm_region}" // global or any region.
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    "HMAC"            = true,
    service-endpoints = "${var.end_pts}"
  }
// User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}


# Apply developer access policy to CMS instance
resource "ibm_iam_access_group_policy" "cms_developer_access_policy" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  roles           = "${split(",", (lookup(var.developer_access, "cms")))}"

  resources = [{
    service              = "cloudcerts"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
  }]

  depends_on = ["null_resource.invite_developer_user"]
}

# Apply manager access policy to CMS instanfe
resource "ibm_iam_access_group_policy" "cms_manager_access_policy" {
  access_group_id = "${ibm_iam_access_group.manager.id}"
  roles           = "${split(",", (lookup(var.manager_access, "cms")))}"

  resources = [{
    service              = "cloudcerts"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
  }]
  depends_on = ["null_resource.invite_manager_user"]
}

# Apply cloud engineer access policy to CMS instance
resource "ibm_iam_access_group_policy" "cms_engineer_access_policy" {
  access_group_id = "${ibm_iam_access_group.cloud_engineer.id}"
  roles           = "${split(",", (lookup(var.cloud_engineer_access, "cms")))}"

  resources = [{
    service              = "cloudcerts"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
  }]
  depends_on = ["null_resource.invite_engineer_user"]
}



# Create authorization policy for LBaaS to read CMS
resource "null_resource" "cms_service_policy_for_lbaas" {
    provisioner "local-exec" {
    command = <<EOT
echo $(curl -X POST \
"https://iam.cloud.ibm.com/v1/policies" \
-H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}' \
-H 'Content-Type: application/json' \
-d '{
  "type": "authorization",
  "subjects": [
    {
      "attributes": [
        { 
          "name": "accountId",
          "value": "${var.account_id}"
        },
        {
          "name": "region",
          "value": "${var.ibm_region}"
        },
        {
          "name": "serviceName",
          "value": "load-balancer-for-vpc"
        },
        {
          "name": "serviceInstance",
          "value": "${element(split(":", ibm_is_lb.multizone_lb.id), 7)}"
        }
      ]
    }
  ],
  "roles":[
    {
      "role_id": "crn:v1:bluemix:public:iam::::serviceRole:Reader"
    }
  ],
  "resources":[
    {  
      "attributes": [
        { 
          "name": "accountId",
          "value": "${var.account_id}"
        },
        {
          "name": "serviceName",
          "value": "cloudcerts"
        },
        {
          "name": "serviceInstance",
          "value": "${element(split(":", ibm_resource_instance.multizone_cms.id), 7)}"
        }
      ]
    }
  ]
}') >> config/lb_cms_policy_id.txt

EOT
  
  }
}

