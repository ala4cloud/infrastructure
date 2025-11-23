module "database" {
  source           = "./database"
  application_name = var.application_name
  environment_name = var.environment_name
  primary_location = var.primary_location
}


module "api" {
  source                         = "./api"
  application_name               = var.application_name
  environment_name               = var.environment_name
  primary_location               = var.primary_location
  app_insights_connection_string = module.monitoring.api_app_insights_connection_string
}

module "webapp" {
  source                           = "./webapp"
  application_name                 = var.application_name
  environment_name                 = var.environment_name
  primary_location                 = var.primary_location
  app_insights_instrumentation_key = module.monitoring.webapp_app_insights_instrumentation_key
  keyvault_github_id               = module.keyvault.keyvault_github_id
}

module "keyvault" {
  source                           = "./keyvault"
  primary_location                 = var.primary_location
  application_name                 = var.application_name
  environment_name                 = var.environment_name
  azurerm_cosmosdb_account_name    = module.database.azurerm_cosmosdb_account_name
  azurerm_cosmosdb_database_name   = module.database.azurerm_cosmosdb_database_name
  container_app_api_pricipal_id    = module.api.container_app_api_principal_id
  app_insights_instrumentation_key = module.monitoring.webapp_app_insights_instrumentation_key
}
module "monitoring" {
  source           = "./monitoring"
  application_name = var.application_name
  environment_name = var.environment_name
  primary_location = var.primary_location
}
