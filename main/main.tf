
module "database" {
  source           = "./database"
  application_name = var.application_name
  environment_name = var.environment_name
  primary_location = var.primary_location
}
