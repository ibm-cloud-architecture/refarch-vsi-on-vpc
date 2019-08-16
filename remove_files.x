resource "null_resource" "remove_token" {

    provisioner "local-exec" {
        command = "rm -rf config"
    }

    depends_on = ["null_resource.create_cos_bucket", "null_resource.key_protect_create_key", "null_resource.key_protect_service_policy_for_cos",
    "null_resource.key_protect_service_policy_for_psql"]
}
