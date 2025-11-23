output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}
output "api_app_insights_connection_string" {
  value = azurerm_application_insights.api.connection_string
}
output "webapp_app_insights_connection_string" {
  value = azurerm_application_insights.webapp
}
output "api_app_insights_instrumentation_key" {
  value = azurerm_application_insights.api.instrumentation_key
}
output "webapp_app_insights_instrumentation_key" {
  value = azurerm_application_insights.webapp.instrumentation_key
}
