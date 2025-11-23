resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-monitoring-${var.environment_name}"
  location = var.primary_location

}


resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.application_name}-${var.environment_name}"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "api" {
  name                = "appi-${var.application_name}-api-${var.environment_name}"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
}
resource "azurerm_application_insights" "webapp" {
  name                = "appi-${var.application_name}-webapp-${var.environment_name}"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
}
