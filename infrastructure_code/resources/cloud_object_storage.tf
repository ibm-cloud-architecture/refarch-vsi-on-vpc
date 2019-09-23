##############################################################################
# This file will create storage resource intances, 
# - creates a cloud object storage instance and a bucket,
# - creates three block volumes used by the VSI in each zone.
##############################################################################


##############################################################################
# Create ICOS instance 
##############################################################################

resource "ibm_resource_instance" "multizone_vpc_cos" {
  name              = "multizone_vpc_cos-${var.unique_id}"
  service           = "cloud-object-storage"
  plan              = "${var.cos_plan}"
  location          = "global" 
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    service-endpoints = "${var.end_points}"
    key_protect_key   = "${file("${path.module}/config/kms_cert.txt")}"
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
# Create COS Bucket
##############################################################################

resource "null_resource" "create_cos_bucket" {
  provisioner "local-exec" {

    command = <<EOT

REGION=${var.ibm_region}
COS_ID=${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}
BUCKET_NAME=${var.cos_bucket_name}
KMS_KEY_CRN=${file("${path.module}/config/kms_cert_crn.txt")}
API_KEY=${var.ibmcloud_apikey}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)

curl -X PUT \
    https://s3.$REGION.objectstorage.softlayer.net/$BUCKET_NAME \
    -H 'Accept: */*' \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: text/xml' \
    -H 'accept-encoding: gzip, deflate' \
    -H 'cache-control: no-cache' \
    -H 'content-length: ' \
    -H "ibm-service-instance-id: $COS_ID" \
    -H 'ibm-sse-kp-encryption-algorithm: AES256' \
    -H "ibm-sse-kp-customer-root-key-crn: $KMS_KEY_CRN"    
    
EOT
  }
  depends_on = ["ibm_resource_instance.multizone_vpc_cos", "null_resource.iam_auth_policy_cos_kms", "null_resource.key_protect_create_key"]
}

##############################################################################



