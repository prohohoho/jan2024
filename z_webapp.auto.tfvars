webapp_config = {
  ddhprdwebappplanfrontend = {
    app_name             = "ddhprdwebapp"
    vnet_name            = "ddhaeastprodvnet"
    subnet_name          = "ddhaeastprodwebappsubnet"
    has_vnet_integration = true

  }

  ddhprdwebappplanbackend = {
    app_name                      = "ddhprdwebapp-api"
    pve_subnet_name               = "ddhaeastprodpesubnet"
    vnet_name                     = "ddhaeastprodvnet"
    has_private_dns_zone          = true
    public_network_access_enabled = false
  }
}



