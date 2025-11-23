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

resource "azurerm_static_web_app" "main" {
  name                               = "alacloud-staticwebapp-dev"
  resource_group_name                = azurerm_resource_group.main.name
  location                           = "westeurope"
  configuration_file_changes_enabled = true
  preview_environments_enabled       = true
  public_network_access_enabled      = true
  repository_branch                  = "main"
  repository_url                     = "https://github.com/ala4cloud/webapp"
  repository_token                   = "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"
  sku_size                           = "Free"
  sku_tier                           = "Free"

  tags = {
    environment = var.environment_name
  }
}


