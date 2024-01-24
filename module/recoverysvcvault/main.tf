resource "azurerm_recovery_services_vault" "vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  soft_delete_enabled = true
}


#############PrivatelinkStart############

resource "azurerm_private_endpoint" "stg" {
  name                = var.privatelink_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id.id

  private_service_connection {
    name                           = var.privatelink_name
    private_connection_resource_id = azurerm_recovery_services_vault.vault.id
    is_manual_connection           = false
    subresource_names              = ["AzureBackup"]
  }
  depends_on = [azurerm_recovery_services_vault.vault]
}

################PrivatelinkEND##############

#FileSharePolicy+#
resource "azurerm_backup_policy_file_share" "fileshare" {
  name                = "${var.name}-fileshare-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  backup {
    frequency = "Daily"
    time      = "21:30"
  }

  retention_daily {
    count = 90 # reduced to half because exceeds allowed retention points
  }
  retention_weekly {
    count    = 12
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 2
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}
#FileSharePolicy-#



#VMPolicy+#
resource "azurerm_backup_policy_vm" "vm" {
  name                           = "${var.name}-vm-policy"
  resource_group_name            = var.resource_group_name
  recovery_vault_name            = azurerm_recovery_services_vault.vault.name
  policy_type                    = "V2"
  instant_restore_retention_days = 7
  timezone                       = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 180
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 5
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}
#VMPolicy-#