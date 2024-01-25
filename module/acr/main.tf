resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_name
  admin_enabled       = var.admin_enabled

  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = "180.190.99.68"
    }

  }
}


###############PrivatelinkStart#############

resource "azurerm_private_endpoint" "sape" {
  name                = var.privatelink_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.pv_subnet_id.id
  private_service_connection {
    name                           = var.privatelink_name
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

################PrivatelinkEND##############