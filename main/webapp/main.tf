resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-webapp-${var.environment_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}

data "azurerm_key_vault_secret" "github_token" {
  name         = "gh-token"
  key_vault_id = var.keyvault_github_id
}
data "azurerm_key_vault_secret" "github-repo" {
  name         = "github-repo"
  key_vault_id = var.keyvault_github_id
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
  repository_url                     = data.azurerm_key_vault_secret.github-repo.value
  repository_token                   = data.azurerm_key_vault_secret.github_token.value
  sku_size                           = "Free"
  sku_tier                           = "Free"

  tags = {
    environment = var.environment_name
  }
}


