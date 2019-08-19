##############################################################################
# This file is used to invite users to the account. The two blocks uses a
# formatted variable that provides the  information for invitations
#  access groups and policy roles. The commented out block is
# supported in the provider to invite users into a CF Org.
##############################################################################



# Invite manager users to the account
  resource "null_resource" "invite_manager_user" {
    count = "${length(split(",", (lookup(var.manager_access, "user"))))}"
    provisioner "local-exec" {
      command = <<EOT
    curl -X POST https://user-management.cloud.ibm.com/v2/accounts/${var.account_id}/users/ \
    -H 'Accept: */*' \
    -H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}' \
    -H 'Host: user-management.cloud.ibm.com' \
    -d '{
      "users": [
      {
        "email": "${element(split(",", (lookup(var.manager_access, "user"))), count.index)}",
       "account_role": "${lookup(var.manager_access, "account_role")}"
      }]
}'

EOT
    }
  }

# Invite  developer users to the account
resource "null_resource" "invite_developer_user" {
  count = "${length(split(",", (lookup(var.developer_access, "user"))))}"
  provisioner "local-exec" {
    command = <<EOT
    curl -X POST https://user-management.cloud.ibm.com/v2/accounts/${var.account_id}/users/ \
    -H 'Accept: */*' \
    -H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}' \
    -H 'Host: user-management.cloud.ibm.com' \
    -d '{
      "users": [
      {
        "email": "${element(split(",", (lookup(var.developer_access, "user"))), count.index)}",
       "account_role": "${lookup(var.developer_access, "account_role")}"
      }]
}'
    
EOT
  }
}

# Invite cloud engineers users to the account
resource "null_resource" "invite_engineer_user" {
  count = "${length(split(",", (lookup(var.cloud_engineer_access, "user"))))}"
  provisioner "local-exec" {
    command = <<EOT
    curl -X POST https://user-management.cloud.ibm.com/v2/accounts/${var.account_id}/users/ \
    -H 'Accept: */*' \
    -H 'Authorization: ${data.null_data_source.iam_auth_token.outputs["token"]}' \
    -H 'Host: user-management.cloud.ibm.com' \
    -d '{
      "users": [
      {
        "email": "${element(split(",", (lookup(var.cloud_engineer_access, "user"))), count.index)}",
       "account_role": "${lookup(var.cloud_engineer_access, "account_role")}"
      }]
    }'

EOT
  }
}



# Optionally invite users to public cloud foundry org

# resource "ibm_org" "org" {
#   name = "myorganization"
#   users = ["test@in.ibm.com"]
# }

# resource "ibm_space" "space" {
#   org = "${ibm_org.org.name}"
#   name = "myspace"
#   developers = ["test@in.ibm.com"]
# }










