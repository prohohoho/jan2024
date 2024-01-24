variable "resource_group_name" {}
variable "location" {}
variable "vm_name" {}
variable "os_hostname" {}
variable "size" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "image_version" {}
variable "admin_username" {}
#commented out the below to test compute module
variable "subnet_id" {}
#variable "vnet_name" {}
variable "akv_name" {}
variable "os_disk_size" {}
variable "recovery_vault_name" {}
variable "backup_policy_id" {}
variable "managed_disks" {
  default     = {}
  description = "List of managed disks to add to the VM"
}


variable "private_ip_address_allocation" {
  default = "Dynamic"
}
variable "private_ip_address" {
  default  = null
  nullable = true
}

variable "tags" {
  type = object({
    environment            = optional(string)
    backup                 = optional(string)
    patching               = optional(string)
    VeeambackupapplianceID = optional(string)


  })
  default     = null
  description = "List of tags"
}