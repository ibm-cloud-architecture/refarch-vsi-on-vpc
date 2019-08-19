##############################################################################
# This file will create a resource instance of Key Protect, authorize
# COS and PostgresSQL data service to access the keys,  creates keys
# and configures key protect for hosting the keys. Assigns IAM policies
# for the three access groups. Resouerce instance will be enabled for private
# endpoint.
##############################################################################


# Create KeyProtect instance
resource "ibm_resource_instance" "multizone_kms" {
  name              = "multizone-key-protect-${var.unique_id}"
  service           = "kms"
  plan              = "${var.kms_plan}"
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


# Apply developer access policy to the Key Protect instance
resource "ibm_iam_access_group_policy" "kms_developer_access_policy" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  roles           = "${split(",", (lookup(var.developer_access, "kms")))}"
  resources = [{
    service              = "kms"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
  }]
  depends_on = ["null_resource.invite_developer_user"]
}

# Apply manager access policy to the Key Protect instance
resource "ibm_iam_access_group_policy" "kms_manager_access_policy" {
  access_group_id = "${ibm_iam_access_group.manager.id}"
  roles           = "${split(",", (lookup(var.manager_access, "kms")))}"

  resources = [{
    service              = "kms"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
  }]
  depends_on = ["null_resource.invite_manager_user"]
}

# Apply cloud engineer access policy to the Key Protect instance
resource "ibm_iam_access_group_policy" "kms_engineer_access_policy" {
  access_group_id = "${ibm_iam_access_group.cloud_engineer.id}"
  roles           = "${split(",", (lookup(var.cloud_engineer_access, "kms")))}"

  resources = [{
    service              = "kms"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
  }]
  depends_on = ["null_resource.invite_engineer_user"]
}


# Create KP Root key and sends JSON output to results.txt  
resource "null_resource" "key_protect_create_key" {
  provisioner "local-exec" {
    command = <<EOT
CERT=$(echo "$(curl -X POST \
https://${var.ibm_region}.kms.cloud.ibm.com/api/v2/keys \
-H 'authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}' \
-H 'bluemix-instance: ${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}' \
-H 'content-type: application/vnd.ibm.kms.key+json' \
-d '{
  "metadata": {
    "collectionType": "application/vnd.ibm.kms.key+json",
    "collectionTotal": 1
  },
  "resources": [
  {
    "type": "application/vnd.ibm.kms.key+json",
    "name": "multizone-root-key",
    "description": "key used for demonstration in multizone",
    "extractable": false
    }
  ]
}')")
echo $CERT
echo $CERT >> config/kms_cert.txt
echo $CERT | jq '.resources[0].id' | cut -d '"' -f 2 >> config/kms_cert_id.txt
    EOT
  }
  depends_on = ["ibm_resource_instance.multizone_kms"]
}


# Stores the key protect root key id to use when runnin terraform destroy
data "null_data_source" "key_protect_root_key" {
  inputs = {
    root_key    = "${file("${path.module}/config/kms_cert.txt")}"
    root_key_id = "${file("${path.module}/config/kms_cert_id.txt")}"
  }
  depends_on = ["null_resource.key_protect_create_key"]
}

# Create authorization policy for COS to read  Key Protect
# Check file cos_policy_id.txt for output or error.
resource "null_resource" "key_protect_service_policy_for_cos" {
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
          "value": "cloud-object-storage"
        },
        {
          "name": "serviceInstance",
          "value": "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
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
          "value": "kms"
        },
        {
          "name": "serviceInstance",
          "value": "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
        }
      ]
    }
  ]
}') >> config/cos_policy_id.txt

EOT
  
  }
depends_on = ["ibm_resource_instance.multizone_kms", "ibm_resource_instance.multizone_vpc_cos"]  
}


# Create authorization policy for PostgresSQL DB to read Key Protect
resource "null_resource" "key_protect_service_policy_for_psql" {
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
          "value": "databases-for-postgresql"
        },
        {
          "name": "serviceInstance",
          "value": "${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}"
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
          "value": "kms"
        },
        {
          "name": "serviceInstance",
          "value": "${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}"
        }
      ]
    }
  ]
}') >> config/psql_policy_id.txt

EOT
  
  
  }
  depends_on = ["ibm_resource_instance.multizone_kms", "ibm_resource_instance.postgresql_resource_instance"]
}

# Stores IAM policyID for key ptotect to refer when running terraform destroy
data "null_data_source" "kms_policy_keys" {
  inputs = {
     cos_policy_key = "${element(split("\"", file("${path.module}/config/cos_policy_id.txt")), 1)}"
     psql_policy_key = "${element(split("\"", file("${path.module}/config/psql_policy_id.txt")), 1)}"
  }
  depends_on = ["null_resource.key_protect_service_policy_for_cos", "null_resource.key_protect_service_policy_for_psql"]
}


# Destroy COS authorization for kp instance, when terraform destroy runs
resource "null_resource" "destroy_cos-kp_authorization" {
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
      echo "curl -X DELETE \
      'https://iam.cloud.ibm.com/v1/policies/${data.null_data_source.kms_policy_keys.outputs["cos_policy_key"]}' \
      -H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}'\
      -H 'Content-Type: application/json'" >> destroy_all_keys.sh
    EOT
  }
  depends_on = ["ibm_resource_instnace.multizone_kms"}
}


# Destroy PostgresSQL key when terraform destroy runs
resource "null_resource" "destroy_postgres-kp_authorization" {
  provisioner "local-exec" {
     when = "destroy"
    command = <<EOT
      echo "curl -X DELETE \
      'https://iam.cloud.ibm.com/v1/policies/${data.null_data_source.kms_policy_keys.outputs["psql_policy_key"]}' \
      -H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}'\
      -H 'Content-Type: application/json'" >> destroy_all_keys.sh
    EOT
  }
}


# Destroys key protect root-keys when terraform destroy runs
resource "null_resource" "destroy_key_protect" {
    provisioner "local-exec" {
      when = "destroy"
      command = <<EOT
  TOKEN=$(echo "$(curl -X POST \
'https://iam.cloud.ibm.com/identity/token' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'grant_type=urn:ibm:params:oauth:grant-type:apikey' \
-d 'apikey=${var.ibmcloud_apikey}')")
WITH_QUOTES=$(echo $TOKEN | jq '.access_token')
TOKEN_RAW=$(echo $WITH_QUOTES | cut -d '"' -f 2)
BEARER=$(echo Bearer $TOKEN_RAW)
INSTANCE_ID=${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}
REGION=${var.ibm_region}
KEY=$(curl -X GET "https://$REGION.kms.cloud.ibm.com/api/v2/keys" \
   -H "authorization: $BEARER" \
   -H "bluemix-instance: $INSTANCE_ID" \
   -H 'accept: application/vnd.ibm.kms.key+json')
KEY_ID=$(echo $KEY | jq '.resources[0].id' | cut -d '"' -f 2)
 echo $KEY_ID
 curl -X DELETE \
"https://$REGION.kms.cloud.ibm.com/api/v2/keys/$KEY_ID" \
-H "authorization: $BEARER" \
-H "bluemix-instance: $INSTANCE_ID" \
-H 'accept: application/vnd.ibm.kms.key+json'
      EOT
    }
  depends_on = ["ibm_resource_instance.multizone_kms"]
}
