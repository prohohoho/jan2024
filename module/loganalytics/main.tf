
resource "azurerm_log_analytics_workspace" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_name #"PerGB2018"
  retention_in_days   = var.retention_days
}

