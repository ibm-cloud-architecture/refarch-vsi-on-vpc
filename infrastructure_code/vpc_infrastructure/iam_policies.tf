##############################################################
# Create authorization policy for LBaaS to read CMS
##############################################################
resource "null_resource" "cms_service_policy_for_lbaas" {
    count = "3"
    provisioner "local-exec" {
    command = <<EOT

ACCOUNT_ID=${var.account_id}
SUBJECT_NAME=load-balancer-for-vpc
SUBJECT_ID="${element(split(":", element(ibm_is_lb.multizone_lb.*.id, count.index)), 7)}"
ROLE_ID=Reader
RESOURCE_NAME=cloudcerts
RESOURCE_ID=${var.cms_id}
API_KEY=${var.ibmcloud_apikey}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)

KEY=$(curl -X POST \
"https://iam.cloud.ibm.com/v1/policies" \
-H "Authorization: Bearer $TOKEN" \
-H 'Content-Type: application/json' \
-d '{
  "type": "authorization",
  "subjects": [
    {
      "attributes": [
        { 
          "name": "accountId",
          "value": "'$ACCOUNT_ID'"
        },
        {
          "name": "serviceName",
          "value": "'$SUBJECT_NAME'"
        },
        {
          "name": "serviceInstance",
          "value": "'$SUBJECT_ID'"
        }
      ]
    }
  ],
  "roles":[
    {
      "role_id": "crn:v1:bluemix:public:iam::::serviceRole:'$ROLE_ID'"
    }
  ],
  "resources":[
    {  
      "attributes": [
        { 
          "name": "accountId",
          "value": "'$ACCOUNT_ID'"
        },
        {
          "name": "serviceName",
          "value": "'$RESOURCE_NAME'"
        },
        {
          "name": "serviceInstance",
          "value": "'$RESOURCE_ID'"
        }
      ]
    }
  ]
}')


EOT
  
  }
}

##############################################################