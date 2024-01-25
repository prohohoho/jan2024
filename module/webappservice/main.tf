resource "azurerm_service_plan" "example" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "example" {
  name                          = var.app_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.example.id
  public_network_access_enabled = var.public_network_access_enabled
  https_only                    = true

  site_config {
    # ftps_state          = "Disabled"
    # minimum_tls_version = "1.2"
    # ip_restriction {
    #   service_tag               = "AzureFrontDoor.Backend"
    #   ip_address                = null
    #   virtual_network_subnet_id = null
    #   action                    = "Allow"
    #   priority                  = 100
    #   headers {
    #     x_azure_fdid      = [var.frontdoorID]
    #     x_fd_health_probe = []
    #     x_forwarded_for   = []
    #     x_forwarded_host  = []
    #   }
    #   name = "Allow traffic from Front Door"
    # }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  count          = var.has_vnet_integration ? 1 : 0
  app_service_id = azurerm_linux_web_app.example.id
  subnet_id      = var.subnet.id
}


##private DNS zone

resource "azurerm_private_dns_zone" "dnsprivatezone" {
  count               = var.has_private_dns_zone ? 1 : 0
  name                = "${var.app_name}.azurewebsites.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  count                 = var.has_private_dns_zone ? 1 : 0
  name                  = "${var.app_name}-dnszonelink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnsprivatezone[count.index].name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "privateendpoint" {
  count               = var.has_private_dns_zone ? 1 : 0
  name                = "${var.app_name}-pvendpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pve_subnet.id

  private_dns_zone_group {
    name                 = "${var.app_name}--pvdnszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone[count.index].id]
  }

  private_service_connection {
    name                           = "${var.app_name}-pvendpointconnection"
    private_connection_resource_id = azurerm_linux_web_app.example.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
