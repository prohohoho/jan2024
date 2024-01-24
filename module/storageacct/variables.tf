#----AZ Resource repetetive Variables Start----#
variable "storage_name" {
}
variable "location" {
}
variable "resource_group_name" {
}
variable "account_tier" {
}
variable "replication_type" {
}

variable "access_tier" {}
variable "account_kind" {}

variable "privatelink_name" {}
variable "subnet_id" {}      #storage account  subnet id
variable "pv_subnet_name" {} #private link  subnet name
variable "pv_subnet_id" {}
variable "vnet_name" {}
variable "allowed_ip_ranges" {}

