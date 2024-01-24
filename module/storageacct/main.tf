resource "azurerm_storage_account" "sa" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  access_tier              = var.access_tier

}

resource "azurerm_storage_account_network_rules" "sanr" {
  storage_account_id = azurerm_storage_account.sa.id

  default_action             = "Deny"
  ip_rules                   = var.allowed_ip_ranges
  virtual_network_subnet_ids = [var.subnet_id.id]
  bypass                     = ["Metrics", "Logging", "AzureServices"]
}



###############PrivatelinkStart#############

resource "azurerm_private_endpoint" "sape" {
  name                = var.privatelink_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.pv_subnet_id.id
  private_service_connection {
    name                           = var.privatelink_name
    private_connection_resource_id = azurerm_storage_account.sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

################PrivatelinkEND##############