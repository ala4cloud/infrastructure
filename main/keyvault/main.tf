resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-keyvault-${var.environment_name}"
  location = var.primary_location

}

data "azurerm_client_config" "current" {}

data "azurerm_cosmosdb_account" "main" {
  name                = var.azurerm_cosmosdb_account_name
  resource_group_name = "rg-${var.application_name}-database-${var.environment_name}"
}
data "azurerm_cosmosdb_sql_database" "main" {
  name                = var.azurerm_cosmosdb_database_name
  resource_group_name = "rg-${var.application_name}-database-${var.environment_name}"
  account_name        = var.azurerm_cosmosdb_account_name
}


resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false

}

resource "azurerm_key_vault" "cosmosdb" {
  name                     = "kv-${var.application_name}-${random_string.suffix.result}-${var.environment_name}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = true
}

resource "azurerm_key_vault_secret" "cosmosdb_name" {
  name         = "cosmosDB-name-${var.environment_name}"
  value        = data.azurerm_cosmosdb_sql_database.main.name
  key_vault_id = azurerm_key_vault.cosmosdb.id
}



resource "azurerm_key_vault_secret" "cosmosdb_connection_string" {
  name         = "cosmosDB-ConnectionString-${var.environment_name}"
  value        = data.azurerm_cosmosdb_account.main.primary_sql_connection_string
  key_vault_id = azurerm_key_vault.cosmosdb.id

  depends_on = [
    data.azurerm_cosmosdb_account.main
  ]
}


resource "azurerm_key_vault_access_policy" "access_to_app_container" {
  key_vault_id = azurerm_key_vault.cosmosdb.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.container_app_api_pricipal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}


