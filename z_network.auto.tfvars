network_configurations = {

  ddhaeastprodvnet = {
    location      = "Australia East"
    address_space = ["10.0.0.0/24"]
    subnets = {
      ddhaeastprodwebappsubnet = {
        nsgname = "ddhaeastprodwebappsubnet-nsg01"
        #service_endpoints = ["Microsoft.KeyVault"]
        address_prefixes = ["10.0.0.0/28"]
        delegation = {
          name                       = "sf"
          service_delegation_name    = "Microsoft.Web/serverFarms"
          service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
        rules = {
          AllowVnet = {
            name                       = "AllowVnet"
            visible_for_dev_only       = true
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "VirtualNetwork"
          }
          DenyAllIn = {
            name                       = "DenyAllIn"
            description                = "DenyAllIn"
            visible_for_dev_only       = true
            priority                   = 1000
            direction                  = "Inbound"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
      ddhaeastprodappgwysubnet = {
        nsgname           = "ddhaeastprodappgwysubnet-nsg01"
        address_prefixes  = ["10.0.0.16/28"]
        service_endpoints = ["Microsoft.Web"]
        rules = {
          Allowrequired = {
            name                       = "Allowrequired"
            visible_for_dev_only       = true
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }

          DenyAllIn = {
            name                       = "DenyAllIn"
            description                = "DenyAllIn"
            visible_for_dev_only       = true
            priority                   = 4000
            direction                  = "Inbound"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
      ddhaeastprodpesubnet = {
        address_prefixes = ["10.0.0.32/28"]
        nsgname          = "ddhaeastprodpesubnet-nsg01"
        rules = {
          DenyAllIn = {
            name                       = "DenyAllIn"
            description                = "DenyAllIn"
            visible_for_dev_only       = true
            priority                   = 1000
            direction                  = "Inbound"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
    }
  }

}
