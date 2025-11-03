#set the subscription
export ARM_SUBSCRIPTION_ID="85aa42d8-be4f-4a89-8192-7889eb82e0cf"

#set the app env 
export TF_VAR_application_name="alacloud"
export TF_VAR_environment_name="prod"
export TF_VAR_primary_location="France Central"

terraform init

terraform $*
rm -rf .terraform