#----AZ Resource repetetive Variables Start----#
variable "resource_group_name" {
  default = "rg-ddh-prod"
  type    = string
}
variable "environment" {
  default = "prod"
  type    = string
}
variable "location" {
  default = "Australia East"
  type    = string
}


variable "kv_allow_ip" {

  default = ["180.190.99.68", "130.105.187.150"

  ]
  type = list(string)
}

#------AZ Resource repetetive Variables end-----#
variable "subscription_id" {
  #ublr
  default = "b6bc174f-3ea1-481b-8d2a-614f2f2e464b"
}
variable "client_id" {
  default = "d438b5db-58d2-47c0-b915-ede22e5df4f4"
}

variable "tenant_id" {
  #ublr
  default = "76e4ac64-f84d-401d-8594-3f6ca5374437"
}
variable "client_secret" {
  default = "5dC8Q~usnhu7QN4UguHTG4YNbtV6-NhWvA3NAbYS"

}



variable "network_configurations" {
  type = map(object({
    location      = optional(string, "australiaeast")
    address_space = list(string)
    subnets = map(object({
      nsgname           = optional(string, null)
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), null)
      delegation = optional(object({
        name                       = optional(string)
        service_delegation_name    = optional(string)
        service_delegation_actions = optional(list(string), [])
      }), null)
      rules = optional(map(object({
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
      })))
    }))
  }))
}
variable "appgw_config" {
  type = map(object({
    location      = optional(string, "australiaeast")
    vnet_name     = string
    subnet_name   = string
    cert_pass     = string
    keyvault_name = string
    secret_name   = string
  }))
}

variable "webapp_config" {
  type = map(object({
    location                      = optional(string, "australiaeast")
    sku_name                      = optional(string, "S1")
    app_name                      = optional(string)
    vnet_name                     = optional(string)
    subnet_name                   = optional(string)
    pve_subnet_name               = optional(string)
    has_vnet_integration          = optional(bool, false)
    has_private_dns_zone          = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
  }))
}
