#############################################################################
# Creates Auth Policy For COS to read from KMS
#############################################################################

resource "null_resource" "iam_auth_policy_cos_kms" {
    provisioner "local-exec" {
    command = <<EOT

API_KEY=${var.ibmcloud_apikey}
ACCOUNT_ID=${var.account_id}
SUBJECT_NAME=cloud-object-storage
SUBJECT_ID=${element(split(":", ibm_resource_instance.multizone_vpc_cos.id), 7)}
ROLE_ID=Reader
RESOURCE_NAME=kms
RESOURCE_ID=${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)

curl -X POST \
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
}'

EOT

  }
 depends_on = ["ibm_resource_instance.multizone_vpc_cos", "ibm_resource_instance.multizone_kms"]  

}

#############################################################################


#############################################################################
# Creates Auth Policy For PostGres to read from KMS
#############################################################################


resource "null_resource" "iam_auth_policy_psql_kms" {
    provisioner "local-exec" {
    command = <<EOT

API_KEY=${var.ibmcloud_apikey}
ACCOUNT_ID=${var.account_id}
SUBJECT_NAME=databases-for-postgresql
SUBJECT_ID=${element(split(":", ibm_resource_instance.postgresql_resource_instance.id), 7)}
ROLE_ID=Reader
RESOURCE_NAME=kms
RESOURCE_ID=${element(split(":", ibm_resource_instance.multizone_kms.id), 7)}

TOKEN=$(echo $(curl -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token") | jq -r .access_token)

curl -X POST \
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
}'

EOT

  }
depends_on = ["ibm_resource_instance.postgresql_resource_instance", "ibm_resource_instance.multizone_kms"]  

}



#############################################################################