output "log_analytics_workspace_id" {
  description = "Returns all the keyvault. As a map of keys, ID"
  value       = azurerm_log_analytics_workspace.example.id
}