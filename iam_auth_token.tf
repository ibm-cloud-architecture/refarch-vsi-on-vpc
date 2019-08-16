##############################################################################
# This file creates an auth token from the provided APIkey
##############################################################################


# Create auth token with APIkey
resource "null_resource" "create_auth_token" {
  provisioner "local-exec" {
    command = <<EOT
    echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=${var.ibmcloud_apikey}" \
      "https://iam.cloud.ibm.com/identity/token") >> config/token.txt
  EOT
  }
}
 

# Export auth token to use for remaining actions
data "null_data_source" "iam_auth_token" {

  inputs = {
    token = "Bearer ${element(split("\":\"", element(split("\",\"", file("${path.module}/config/token.txt")), 0)),1)}"
  }
  depends_on = ["null_resource.create_auth_token"]
}
