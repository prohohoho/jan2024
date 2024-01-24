resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "networking" {
  source   = "./module/networking"
  for_each = var.network_configurations

  environment         = var.environment
  resource_group_name = azurerm_resource_group.example.name
  location            = each.value.location
  vnet_name           = each.key
  address_space       = each.value.address_space
  subnets             = each.value.subnets
}


module "appgw" {
  source   = "./module/appgateway"
  for_each = var.appgw_config

  appgw_name          = each.key
  vnet_name           = each.value.vnet_name
  resource_group_name = azurerm_resource_group.example.name
  location            = each.value.location
  subnet              = module.networking[each.value.vnet_name].subnets[each.value.subnet_name]
  cert_pass           = each.value.cert_pass
  keyvault_name       = each.value.keyvault_name
  secret_name         = each.value.secret_name
}

module "frontendwebapp" {
  source              = "./module/frontendwebappservice"
  for_each            = var.frontendwebapp_config
  plan_name           = each.key
  app_name            = each.value.app_name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.example.name
  allowed_ip_ranges   = var.kv_allow_ip
  sku_name            = each.value.sku_name
  subnet              = module.networking[each.value.vnet_name].subnets[each.value.subnet_name]
  vnet_id             = module.networking[each.value.vnet_name].vnet.vnet_id

}

module "backendwebapp" {
  source              = "./module/backendwebappservice"
  for_each            = var.backendwebapp_config
  plan_name           = each.key
  app_name            = each.value.app_name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.example.name
  allowed_ip_ranges   = var.kv_allow_ip
  sku_name            = each.value.sku_name
  vnet_id             = module.networking[each.value.vnet_name].vnet.vnet_id
  pve_subnet          = module.networking[each.value.vnet_name].subnets[each.value.pve_subnet_name]


}