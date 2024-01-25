output "appgwpip" {
  description = "return pip name"
  value       = azurerm_public_ip.publicip
}

output "appgw" {
  description = "return appgw name"
  value       = azurerm_application_gateway.network
}