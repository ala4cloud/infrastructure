#set the subscription
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

#set the app env 
export TF_VAR_application_name="alacloud"
export TF_VAR_environment_name="dev"

export TF_VAR_primary_location="westus3"



export BACKEND_RESOURCE_GROUP=$(terraform -chdir=../init output -state="terraform.tfstate.d/${TF_VAR_environment_name}/terraform.tfstate" -raw resource_group_name)
export BACKEND_STORAGE_ACCOUNT=$(terraform -chdir=../init output -state="terraform.tfstate.d/${TF_VAR_environment_name}/terraform.tfstate" -raw storage_account_name)
export BACKEND_STORAGE_CONTAINER=$(terraform -chdir=../init output -state="terraform.tfstate.d/${TF_VAR_environment_name}/terraform.tfstate" -raw container_name)
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name


echo "rs group : " $BACKEND_RESOURCE_GROUP
echo "BACKEND_STORAGE_ACCOUNT : " $BACKEND_STORAGE_ACCOUNT 
echo "BACKEND_STORAGE_CONTAINER :" $BACKEND_STORAGE_CONTAINER



terraform init \
  -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
  -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
  -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
  -backend-config="key=${BACKEND_KEY}"



terraform $*

rm -rf .terraform