resource "azurerm_resource_group" "sftp_group" {
  name = "sftp_resource_group"
  location = "East US"
}

resource "azurerm_storage_account" "sftp_account_accl" {
  name = "developmentsftpazure"
  location = azurerm_resource_group.sftp_group.location
  resource_group_name = azurerm_resource_group.sftp_group.name
  account_tier = "Standard"
  min_tls_version ="TLS1_2"
  account_replication_type = "LRS"
  is_hns_enabled = true
  sftp_enabled = true

  tags = merge(local.tags, {
    workload = "data lake"
  })
}

resource "azurerm_storage_container" "sftp_container" {
  name = "sftpcontainer"
  storage_account_name = azurerm_storage_account.sftp_account_accl.name
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.sftp_account_accl ]
  
}

resource "azurerm_storage_account_local_user" "user1sftp" {
  name = "user1sftp"
  storage_account_id = azurerm_storage_account.sftp_account_accl.id
  ssh_key_enabled = true
  ssh_password_enabled = true
  home_directory = "example_path"
  ssh_authorized_key {
    description = "user1sftp"
    key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }
  
  permission_scope {
    permissions {
      read = true
      create = true
    }
    service = "blob"
    resource_name = azurerm_storage_container.sftp_container.name
  }
}




