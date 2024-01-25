# Generate random value for the login password
resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}

resource "azurerm_private_dns_zone" "dzone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink" {
  name                  = var.vnetlink_name
  private_dns_zone_name = azurerm_private_dns_zone.dzone.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
}


# data "azurerm_key_vault" "kv" {
#   name                = var.akv_name
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_key_vault_secret" "db-admin-key" {
#   name         = "${var.db_name}-dbkeypass"
#   value        = random_password.password.result
#   key_vault_id = data.azurerm_key_vault.kv.id
# }


resource "azurerm_mysql_flexible_server" "azmfs" {
  name                   = var.db_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.administrator_login
  administrator_password = ")A}@E3q9qP" #random_password.password.result
  backup_retention_days  = 7
  delegated_subnet_id    = var.subnet_id.id
  private_dns_zone_id    = azurerm_private_dns_zone.dzone.id
  sku_name               = var.sku_name

  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnetlink]
}

resource "azurerm_mysql_flexible_server_firewall_rule" "azmfsrule" {
  name                = var.firewall_rule_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.azmfs.name
  start_ip_address    = var.firewall_start_ip
  end_ip_address      = var.firewall_end_ip
}
