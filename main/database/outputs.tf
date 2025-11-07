
output "azurerm_cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.main.name
}


output "azurerm_cosmosdb_database_name" {
  value = azurerm_cosmosdb_sql_database.main.name
}
