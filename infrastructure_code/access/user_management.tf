##############################################################################
# This file is used to invite users to the account. The two blocks uses a
# formatted variable that provides the  information for invitations
#  access groups and policy roles. The commented out block is
# supported in the provider to invite users into a CF Org.
##############################################################################



##############################################################################
# Invite Developer Users
##############################################################################

resource "null_resource" "invite_developer_users" {
  provisioner "local-exec" {
    command = <<EOT
    
ACCOUNT_ID=${var.account_id}
EMAIL_RAW=${lookup(var.developer_access, "user")}
ROLE="${lookup(var.developer_access, "postgresql")}"
API_KEY=${var.ibmcloud_apikey}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)


EMAIL_ARR=$(echo $EMAIL_RAW | sed 's/,/ /g')
JSON_FORMAT='{"email":"%s","account_role":"%s"},'

JSON_STRING=$(bash -c '
arr=($0)
for EMAIL in "$${arr[@]}"; do 
    JSON_STRING+=$(printf "$1" "$EMAIL" "$2")
done
echo $JSON_STRING' "$EMAIL_ARR" $JSON_FORMAT $ROLE)

USERS_ARRAY=$${JSON_STRING%?}

curl -X POST https://user-management.cloud.ibm.com/v2/accounts/$ACCOUNT_ID/users/ \
-H 'Accept: */*' \
-H "Authorization: Bearer $TOKEN" \
-H 'Host: user-management.cloud.ibm.com' \
-d '{
  "users": ['$USERS_ARRAY']
}'
 
EOT
  }
}

##############################################################################


##############################################################################
# Invite Manager Users
##############################################################################

resource "null_resource" "invite_manager_users" {
  provisioner "local-exec" {
    command = <<EOT
    
ACCOUNT_ID=${var.account_id}
EMAIL_RAW=${lookup(var.manager_access, "user")}
ROLE="${lookup(var.manager_access, "postgresql")}"
API_KEY=${var.ibmcloud_apikey}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)


EMAIL_ARR=$(echo $EMAIL_RAW | sed 's/,/ /g')
JSON_FORMAT='{"email":"%s","account_role":"%s"},'
JSON_STRING=$(bash -c '
arr=($0)
for EMAIL in "$${arr[@]}"; do 
    JSON_STRING+=$(printf "$1" "$EMAIL" "$2")
done
echo $JSON_STRING' "$EMAIL_ARR" $JSON_FORMAT $ROLE)

USERS_ARRAY=$${JSON_STRING%?}

curl -X POST https://user-management.cloud.ibm.com/v2/accounts/$ACCOUNT_ID/users/ \
-H 'Accept: */*' \
-H "Authorization: Bearer $TOKEN" \
-H 'Host: user-management.cloud.ibm.com' \
-d '{
  "users": ['$USERS_ARRAY']
}'
 
EOT
  }
}

##############################################################################


##############################################################################
# Invite Engineer Users
##############################################################################

resource "null_resource" "invite_engineer_users" {
  provisioner "local-exec" {
    command = <<EOT
    
ACCOUNT_ID=${var.account_id}
EMAIL_RAW=${lookup(var.engineer_access, "user")}
ROLE="${lookup(var.engineer_access, "postgresql")}"
API_KEY=${var.ibmcloud_apikey}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)


EMAIL_ARR=$(echo $EMAIL_RAW | sed 's/,/ /g')
JSON_FORMAT='{"email":"%s","account_role":"%s"},'
JSON_STRING=JSON_STRING=$(bash -c '
arr=($0)
for EMAIL in "$${arr[@]}"; do 
    JSON_STRING+=$(printf "$1" "$EMAIL" "$2")
done
echo $JSON_STRING' "$EMAIL_ARR" $JSON_FORMAT $ROLE)

USERS_ARRAY=$${JSON_STRING%?}

curl -X POST https://user-management.cloud.ibm.com/v2/accounts/$ACCOUNT_ID/users/ \
-H 'Accept: */*' \
-H "Authorization: Bearer $TOKEN" \
-H 'Host: user-management.cloud.ibm.com' \
-d '{
  "users": ['$USERS_ARRAY']
}'
 
EOT
  }
}

##############################################################################

##############################################################################
# Optionally invite users to public cloud foundry org
##############################################################################

# resource "ibm_org" "org" {
#   name = "myorganization"
#   users = ["test@in.ibm.com"]
# }

# resource "ibm_space" "space" {
#   org = "${ibm_org.org.name}"
#   name = "myspace"
#   developers = ["test@in.ibm.com"]
# }










