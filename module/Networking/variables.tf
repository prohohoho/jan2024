variable "address_space" {
  type = list(string)
}
variable "resource_group_name" {}
variable "location" {}

variable "vnet_name" {}
variable "environment" {}

variable "subnets" {
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), null)
    nsgname           = string

    delegation = optional(object({
      name                       = optional(string)
      service_delegation_name    = optional(string)
      service_delegation_actions = optional(list(string), [])
    }), null)

    rules = map(object({
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    }))
    diagnostic_account_id = optional(string)
  }))
}

