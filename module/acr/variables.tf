#----AZ Resource repetetive Variables Start----#
variable "name" {
}
variable "location" {
}
variable "resource_group_name" {
}
variable "admin_enabled" {
}
variable "sku_name" {
}

variable "subresource_names" {}
variable "default_action" {}

variable "privatelink_name" {}
variable "subnet_id" {}      #storage account  subnet id
variable "pv_subnet_name" {} #private link  subnet name
variable "pv_subnet_id" {}
variable "vnet_name" {}
variable "allowed_ip_ranges" {}

