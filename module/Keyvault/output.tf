output "kv" {
  description = "Returns all the keyvault. As a map of keys, ID"
  value       = azurerm_key_vault.kv
}

output "kv_name" {
  description = "Returns all the keyvault. As a map of keys, ID"
  value       = azurerm_key_vault.kv.name
}