resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-database-${var.environment_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}

resource "azurerm_cosmosdb_account" "main" {
  name                = "tfex-cosmosdb-account-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  geo_location {
    location          = var.primary_location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

}


resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "tfex-cosmos-sql-db${random_string.suffix.result}"
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
  throughput          = 400
}


resource "azurerm_cosmosdb_sql_container" "main" {
  name                  = "skills"
  resource_group_name   = azurerm_cosmosdb_account.main.resource_group_name
  account_name          = azurerm_cosmosdb_account.main.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths   = ["/field"]
  partition_key_version = 1
  throughput            = 400

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

}





