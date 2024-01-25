output "vnet" {
  value = {
    "vnet_name"          = azurerm_virtual_network.vnet.name
    "vnet_id"            = azurerm_virtual_network.vnet.id
    "vnet_rg"            = azurerm_virtual_network.vnet.resource_group_name
    "vnet_location"      = azurerm_virtual_network.vnet.location
    "vnet_address_space" = azurerm_virtual_network.vnet.address_space
  }
}
output "subnets" {
  description = "Returns all the subnets objects in the Virtual Network. As a map of keys, ID"
  value       = azurerm_subnet.subnet
}