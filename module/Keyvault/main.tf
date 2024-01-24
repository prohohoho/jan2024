resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
  purge_protection_enabled   = true

  sku_name = "standard"

  network_acls {
    bypass                     = "AzureServices"
    default_action             = var.net_acls_def_action
    ip_rules                   = var.allowed_ip_ranges
    virtual_network_subnet_ids = [var.subnet_id.id]
  }

}


#############PrivatelinkStart############

# resource "azurerm_private_endpoint" "stg" {
#   name                = var.privatelink_name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   subnet_id           = var.pv_subnet_id.id

#   private_service_connection {
#     name                           = var.privatelink_name
#     private_connection_resource_id = azurerm_key_vault.kv.id
#     is_manual_connection           = false
#     subresource_names              = ["vault"]
#   }
# }

# ################PrivatelinkEND##############