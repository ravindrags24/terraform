output "sftp_account_accl" {
    value = azurerm_storage_account.sftp_account_accl.name
}

output "deployment_name" {
    value = azurerm_storage_container.sftp_container.name
}

