output "appgwpip" {
  description = "return pip name"
  value       = azurerm_public_ip.publicip
}

output "appgwhttp" {
  description = "return appgw name"
  value       = azurerm_application_gateway.httpnetwork
}

output "appgwhttps" {
  description = "return appgw name"
  value       = azurerm_application_gateway.httpnetwork
}