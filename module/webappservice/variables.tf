#----AZ Resource repetetive Variables Start----#
variable "plan_name" {
}
variable "app_name" {
}
variable "location" {
}
variable "resource_group_name" {
}
variable "allowed_ip_ranges" {}

variable "sku_name" {
}

variable "subnet" {}
variable "pve_subnet" {}
variable "vnet_id" {}

variable "has_vnet_integration" {}
variable "has_private_dns_zone" {}
variable "public_network_access_enabled" {}