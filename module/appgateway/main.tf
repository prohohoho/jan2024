
data "azurerm_key_vault" "existing" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault_secret" "example" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.existing.id
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.appgw_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  #generic
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"


  # App1
  backend_address_pool_name = "${var.vnet_name}-beap"
  http_setting_name         = "${var.vnet_name}-be-htst"
  probe_name                = "${var.vnet_name}-be-probe-app"

  #https Listener port 443
  frontend_port_name_https        = "${var.vnet_name}-feport-https"
  listener_name_https             = "${var.vnet_name}-lstn-https"
  request_routing_rule_name_https = "${var.vnet_name}-rqrt-https"
  ssl_certificate_name            = "my-cert-1"


  #http Listener port 80
  listener_name_http             = "${var.vnet_name}-lstn-http"
  request_routing_rule_name_http = "${var.vnet_name}-rqrt-http"
  frontend_port_name_http        = "${var.vnet_name}-feport-http"
}

resource "azurerm_application_gateway" "network" {
  name                = var.appgw_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_version = "3.2"
  }
  gateway_ip_configuration {
    name      = "${var.appgw_name}-gw-ip-config"
    subnet_id = var.subnet.id

  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.publicip.id

  }

  backend_address_pool {
    name = local.backend_address_pool_name

  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  # Frontend Port  - HTTP Port 80
  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }

  # Frontend Port  - HTTP Port 443
  frontend_port {
    name = local.frontend_port_name_https
    port = 443
  }

  # HTTP Listener - Port 80
  http_listener {
    name                           = local.listener_name_http
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_http
    protocol                       = "Http"
  }
  # HTTPS Listener - Port 443  
  http_listener {
    name                           = local.listener_name_https
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_https
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_certificate_name
    # custom_error_configuration {
    #   custom_error_page_url = "${azurerm_storage_account.storage_account.primary_web_endpoint}502.html"
    #   status_code = "HttpStatus502"
    # }
    # custom_error_configuration {
    #   custom_error_page_url = "${azurerm_storage_account.storage_account.primary_web_endpoint}403.html"
    #   status_code = "HttpStatus403"
    # }    
  }

  # HTTP Routing Rule - HTTP to HTTPS Redirect
  request_routing_rule {
    name                        = local.request_routing_rule_name_http
    rule_type                   = "Basic"
    http_listener_name          = local.listener_name_http
    redirect_configuration_name = local.redirect_configuration_name
  }



  #Redirect Config for HTTP to HTTPS Redirect  
  redirect_configuration {
    name                 = local.redirect_configuration_name
    redirect_type        = "Permanent"
    target_listener_name = local.listener_name_https
    include_path         = true
    include_query_string = true
  }

  # SSL Certificate Block
  ssl_certificate {
    name     = local.ssl_certificate_name
    password = var.cert_pass
    #data     = filebase64("${path.module}/ssl-self-signed/httpd.pfx")
    #data     = filebase64("${path.module}/output.tf")
    data = data.azurerm_key_vault_secret.example.value
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name_http
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_http
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  # HTTPS Routing Rule - Port 443
  request_routing_rule {
    name                       = local.request_routing_rule_name_https
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_https
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

}

