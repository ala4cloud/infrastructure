
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

module "keyvault" {
  source                         = "./keyvault"
  primary_location               = var.primary_location
  application_name               = var.application_name
  environment_name               = var.environment_name
  azurerm_cosmosdb_account_name  = module.database.azurerm_cosmosdb_account_name
  azurerm_cosmosdb_database_name = module.database.azurerm_cosmosdb_database_name
}
