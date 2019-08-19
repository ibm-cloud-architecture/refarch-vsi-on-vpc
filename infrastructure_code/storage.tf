##############################################################################
# This file will create storage resource intances, 
# - creates a cloud object storage instance and a bucket,
# - creates three block volumes used by the VSI in each zone.
##############################################################################



# Create ICOS instance 
resource "ibm_resource_instance" "multizone_vpc_cos" {
  name              = "multizone_vpc_cos-${var.unique_id}"
  service           = "cloud-object-storage"
  plan              = "${var.cos_plan}"
  location          = "global" 
  resource_group_id = "${var.resource_group_id}"
  tags              = ["multizone"]

  parameters = {
    service-endpoints = "${var.end_pts}"
    key_protect_key   = "${data.null_data_source.key_protect_keys.outputs["root_key"]}"
  }
  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}


# Create regional ICOS bucket
resource "null_resource" "create_cos_bucket" {
  provisioner "local-exec" {
    command = <<EOT
    curl -X PUT \
  https://s3.${var.ibm_region}.objectstorage.softlayer.net/${var.cos_bucket_name} \
  -H 'Accept: */*' \
  -H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: text/xml' \
  -H 'accept-encoding: gzip, deflate' \
  -H 'cache-control: no-cache' \
  -H 'content-length: ' \
  -H 'ibm-service-instance-id: ${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}' \
  -H 'ibm-sse-kp-encryption-algorithm: "AES256"' \
  -H 'ibm-sse-kp-customer-root-key-crn: ${data.null_data_source.key_protect_keys.outputs["root_key"]}'
    
EOT
  }
  depends_on = ["ibm_resource_instance.multizone_vpc_cos"]
}


# Apply developer access policy to ICOS 
resource "ibm_iam_access_group_policy" "cos_developer_access_policy" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  roles = "${split(",", (lookup(var.developer_access, "cos")))}"
  resources = [{
    service = "cloud-object-storage"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
  }]
  depends_on = ["null_resource.invite_developer_user"]
}


# Apply manager access policy to ICOS
resource "ibm_iam_access_group_policy" "cos_manager_access_policy" {
  access_group_id = "${ibm_iam_access_group.manager.id}"
  roles = "${split(",", (lookup(var.manager_access, "cos")))}"

  resources = [{
    service = "cloud-object-storage"
    resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
  }]
  depends_on = ["null_resource.invite_manager_user"]
}


# Apply cloud engineer access policy to ICOS
resource "ibm_iam_access_group_policy" "cloud_engineers_access_policy" {
  access_group_id = "${ibm_iam_access_group.cloud_engineer.id}"
  roles = "${split(",", (lookup(var.cloud_engineer_access, "cos")))}"

  resources = [
    {
      service = "cloud-object-storage"
      resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
  }]
  depends_on = [
  "null_resource.invite_engineer_user"]
}


# Apply developer access policy to ICOS bucket
resource "ibm_iam_access_group_policy" "bucket_developer_access_policy" {
  access_group_id = "${ibm_iam_access_group.developer.id}"
  roles = "${split(",", (lookup(var.developer_access, "cos")))}"

  resources = [
    {
      service = "cloud-object-storage"
      resource_instance_id = "${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}"
      resource_type = "bucket"
      resource = "${var.cos_bucket_name}"
  }]
  depends_on = [
    "null_resource.invite_developer_user",
  "null_resource.create_cos_bucket"]
}


# Create block storage (data) volumes that will be attached to VSIs
resource "ibm_is_volume" "multizone_data_volume" {
  count = "${var.vsi_count}"
  name     = "multizone-datavol-${var.unique_id}-${count.index + 1}"
  profile  = "10iops-tier"
  zone     = "${var.ibm_region}-${(count.index % 3) + 1}"
  capacity = 50
  resource_group = "${var.resource_group_id}"
}
