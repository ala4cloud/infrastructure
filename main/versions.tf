terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.50.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  backend "azurerm" {
  }

}

provider "azurerm" {
  features {}
}

data "azurerm_key_vault_secret" "github_token" {
  name         = "gh-token"
  key_vault_id = module.keyvault.keyvault_github_id
}
data "azurerm_key_vault_secret" "github_owner" {
  name         = "github-owner"
  key_vault_id = module.keyvault.keyvault_github_id
}
provider "github" {
  token = data.azurerm_key_vault_secret.github_token.value
  owner = data.azurerm_key_vault_secret.github_owner.value
}
