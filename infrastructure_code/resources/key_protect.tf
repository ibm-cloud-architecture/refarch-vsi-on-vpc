##############################################################################
# Create Key Protect Instance
##############################################################################

resource "ibm_resource_instance" "multizone_kms" {
  name              = "multizone-key-protect-${var.unique_id}"
  service           = "kms"
  plan              = "${var.kms_plan}"
  location          = "${var.ibm_region}" 
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]
  
  parameters = {
    service-endpoints = "${var.end_points}"
  }
  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################


##############################################################################
# Create KMS Root Key
# Writes data to kms_cert.txt and kms_cert_id.txt
##############################################################################

resource "null_resource" "key_protect_create_key" {
  provisioner "local-exec" {
    command = <<EOT

REGION=${var.ibm_region}
API_KEY=${var.ibmcloud_apikey}
KMS_INSTANCE_ID=${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}
ROOT_KEY_NAME=todd

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)

CERT=$(curl -X POST \
https://$REGION.kms.cloud.ibm.com/api/v2/keys \
-H "authorization: Bearer $TOKEN" \
-H "bluemix-instance: $KMS_INSTANCE_ID" \
-H 'content-type: application/vnd.ibm.kms.key+json' \
-d '{
  "metadata": {
    "collectionType": "application/vnd.ibm.kms.key+json",
    "collectionTotal": 1
  },
  "resources": [
  {
    "type": "application/vnd.ibm.kms.key+json",
    "name": "'$ROOT_KEY_NAME'",
    "description": "key used for demonstration in multizone",
    "extractable": false
    }
  ]
}' | jq ".resources[0]")

echo "$CERT" >> resources/config/kms_cert.txt
echo $CERT | jq -r .id | tr -d '\n' >> resources/config/kms_cert_id.txt
echo $CERT | jq -r .crn | tr -d '\n' >> resources/config/kms_cert_crn.txt
    EOT
  }
  depends_on = ["ibm_resource_instance.multizone_kms"]
}

##############################################################################


##############################################################################
# Outputs the JSON root key and JSON root key id when the script finishes
#
# Reference as:
# - data.null_data_source.key_protect_root_key.outputs["root_key"]
# - data.null_data_source.key_protect_root_key.outputs["root_key_id"]
# - data.null_data_source.key_protect_root_key.outputs["root_key_crn"]
##############################################################################

data "null_data_source" "key_protect_root_key" {
  inputs = {
    root_key     = "${file("resources/config/kms_cert.txt")}"
    root_key_id  = "${file("resources/config/kms_cert_id.txt")}"
    root_key_crn = "${file("resources/config/kms_cert_crn.txt")}"
  }
  depends_on = ["null_resource.key_protect_create_key"]
}
#############################################################################


#############################################################################
# Destroys key protect root key before the kms instance is destroyed
#############################################################################

resource "null_resource" "destroy_key_protect" {
    provisioner "local-exec" {
      when = "destroy"
      command = <<EOT

API_KEY=${var.ibmcloud_apikey}
REGION=${var.ibm_region}
KMS_INSTANCE_ID=${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}
KMS_ID_TXT_FILE=resources/config/kms_cert_id.txt

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)

KEY_ID=$(cat $KMS_ID_TXT_FILE)

curl -X DELETE \
"https://$REGION.kms.cloud.ibm.com/api/v2/keys/$KEY_ID" \
-H "authorization: Bearer $TOKEN" \
-H "bluemix-instance: $KMS_INSTANCE_ID" \
-H 'accept: application/vnd.ibm.kms.key+json'

      EOT
    }
  depends_on = ["ibm_resource_instance.multizone_kms"]
}

##############################################################################