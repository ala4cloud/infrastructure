resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-webapp-${var.environment_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}


#azure containter registry creation
resource "azurerm_container_registry" "main" {
  name                = "cr${var.application_name}webapp${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "France Central"
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    environment = var.environment_name
  }
}
