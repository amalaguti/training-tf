resource "random_string" "random-name" {
  length  = 8
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_storage_account" "tfstate" {
  name                = "sa${random_string.random-name.result}"
  resource_group_name = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false

  tags = {
    env   = "training"
    owner = "adrian"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
