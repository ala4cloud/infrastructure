resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-api-${var.environment_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}


#azure containter registry creation
resource "azurerm_container_registry" "main" {
  name                = "cr${var.application_name}api${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "France Central"
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    environment = var.environment_name
  }
}

# Log workspace for the container
resource "azurerm_log_analytics_workspace" "container_workspace" {
  name                = "workspace-alacloud-env-container-dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment_name
  }
}

# Azure Container App ENV
resource "azurerm_container_app_environment" "main" {
  name                       = "managed-env-alacloud-api-dev"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.container_workspace.id

  tags = {
    environment = var.environment_name
  }
}

# Azure Container App 
resource "azurerm_container_app" "container_api" {
  name                         = "alacloud-container-api-dev"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  identity {
    type = "SystemAssigned"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.main.admin_password
  }
  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "registry-password"
  }
  ingress {
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
    target_port                = 80
    external_enabled           = true
    allow_insecure_connections = true

  }


  template {
    container {

      name   = "alacloud-container-api-dev"
      image  = "cralacloudapidev.azurecr.io/github-action/container-app:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = "Development"
      }
      env {
        name  = "KEY_VAULT_NAME"
        value = "kv-alacloud-cosmosdb-dev"
      }
      env {
        name  = "APPINSIGHTS_CONNECTION_STRING"
        value = var.app_insights_connection_string
      }
    }
  }

  tags = {
    environment = var.environment_name
  }
}




