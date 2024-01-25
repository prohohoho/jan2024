resource "azurerm_public_ip" "pipngw01" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "ngw01" {
  name                = "${var.pip_name}-PIPPrefix"
  resource_group_name = var.resource_group_name
  location            = var.location
  prefix_length       = 30
}

resource "azurerm_nat_gateway" "ngw01" {
  name                    = var.natgw_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "ngw01" {
  nat_gateway_id       = azurerm_nat_gateway.ngw01.id
  public_ip_address_id = azurerm_public_ip.pipngw01.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "ngw01" {
  nat_gateway_id      = azurerm_nat_gateway.ngw01.id
  public_ip_prefix_id = azurerm_public_ip_prefix.ngw01.id
}

resource "azurerm_subnet_nat_gateway_association" "ngw01" {
  subnet_id      = var.subnet_id.id
  nat_gateway_id = azurerm_nat_gateway.ngw01.id
}

