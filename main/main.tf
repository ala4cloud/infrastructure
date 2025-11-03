
module "database" {
  source           = "./database"
  application_name = var.application_name
  environment_name = var.environment_name
  primary_location = var.primary_location
}


module "api" {
  source           = "./api"
  application_name = var.application_name
  environment_name = var.environment_name
  primary_location = var.primary_location
}

module "webapp" {
  source           = "./webapp"
  application_name = var.application_name
  environment_name = var.environment_name
  primary_location = var.primary_location
}
