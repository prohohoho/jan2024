resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name = "${var.vm_name}-nic-ipconfig"
    #commented out the below to test compute module
    subnet_id                     = var.subnet_id.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  allow_extension_operations      = true
  computer_name                   = var.os_hostname

  network_interface_ids = [
  azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

data "azurerm_key_vault" "kv" {
  name                = var.akv_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "vm-admin-key" {
  name         = "${var.vm_name}-vmkeypass"
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_managed_disk" "disk" {
  for_each = { for x in var.managed_disks : x.name => x if length(var.managed_disks) > 0 }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = "Premium_LRS"
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk" {
  for_each = { for x in var.managed_disks : x.name => x if length(var.managed_disks) > 0 }

  managed_disk_id    = azurerm_managed_disk.disk[each.value.name].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = each.value.lun
  caching            = each.value.caching
}



resource "azurerm_backup_protected_vm" "vm1" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vm.id
  backup_policy_id    = var.backup_policy_id
}