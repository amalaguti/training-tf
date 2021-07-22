output "resource_group" {
  description = "The resource group name"
  value = azurerm_resource_group.demo.name
}

output "storage_account" {
  description = "The storage account name"
  value = azurerm_storage_account.tfstate.name
}
