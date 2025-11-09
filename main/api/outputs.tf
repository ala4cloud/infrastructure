

output "container_app_api_principal_id" {
  value = azurerm_container_app.container_api.identity[0].principal_id
}
