output "storage_account_id" {
  description = "Returns all the keyvault. As a map of keys, ID"
  value       = azurerm_storage_account.sa.id
}