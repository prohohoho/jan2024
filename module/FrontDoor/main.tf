
resource "azurerm_cdn_frontdoor_profile" "my_front_door" {
  name                = var.front_door_profile_name
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "my_endpoint" {
  name                     = "${var.front_door_profile_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.my_front_door.id
}

resource "azurerm_cdn_frontdoor_origin_group" "my_origin_group" {
  name                     = "${var.front_door_profile_name}-origin-grp"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.my_front_door.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_public_ip" "example" {
  name                = var.appgwpip.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_cdn_frontdoor_origin" "my_app_service_origin" {
  name                          = "${var.front_door_profile_name}-origin-door1"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.my_origin_group.id

  enabled                        = true
  host_name                      = azurerm_public_ip.example.ip_address
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_public_ip.example.ip_address #var.hostname_01
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}


resource "azurerm_cdn_frontdoor_route" "my_route" {
  name                          = "${var.front_door_profile_name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.my_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.my_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.my_app_service_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}