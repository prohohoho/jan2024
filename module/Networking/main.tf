resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "subnet" {
  for_each = {
    for k, v in var.subnets : k => v
  }
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
  dynamic "delegation" {
    for_each = try(each.value.delegation, null) == null ? [] : [each.value.delegation]
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = delegation.value.service_delegation_actions
      }
    }
  }
}


resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for k, v in var.subnets : k => v
    if v.nsgname != null
  }

  name                = each.value.nsgname
  location            = azurerm_virtual_network.vnet.location
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  dynamic "security_rule" {
    for_each = try(each.value.rules, tomap({}))

    content {
      name      = security_rule.key
      priority  = security_rule.value.priority
      direction = security_rule.value.direction
      access    = security_rule.value.access
      protocol  = security_rule.value.protocol

      source_port_range                     = try(security_rule.value.source_port_range, null)
      source_port_ranges                    = try(security_rule.value.source_port_ranges, null)
      source_address_prefix                 = try(security_rule.value.source_address_prefix, null)
      source_address_prefixes               = try(security_rule.value.source_address_prefixes, null)
      source_application_security_group_ids = try(security_rule.value.source_application_security_group_ids, null)

      destination_port_range                     = try(security_rule.value.destination_port_range, null)
      destination_port_ranges                    = try(security_rule.value.destination_port_ranges, null)
      destination_address_prefix                 = try(security_rule.value.destination_address_prefix, null)
      destination_address_prefixes               = try(security_rule.value.destination_address_prefixes, null)
      destination_application_security_group_ids = try(security_rule.value.destination_application_security_group_ids, null)
    }
  }

  tags = {
    environment = var.environment
  }

}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each = {
    for k, v in var.subnets : k => v
  }

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}