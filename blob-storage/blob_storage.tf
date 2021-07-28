resource "random_string" "random-name" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_storage_account" "trainingsa" {
  name                     = "trainingsa${random_string.random-name.result}"
  location                 = azurerm_resource_group.demo.location
  resource_group_name      = azurerm_resource_group.demo.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "trainingco" {
  name                  = "trainingco${random_string.random-name.result}"
  storage_account_name  = azurerm_storage_account.trainingsa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "training-file" {
  name                   = "traningfile.txt"
  storage_account_name   = azurerm_storage_account.trainingsa.name
  storage_container_name = azurerm_storage_container.trainingco.name
  type                   = "Block"
  source                 = "traningfile.txt"
}


data "azurerm_subscription" "primary" {}
#data "azurerm_client_config" "current" {}

resource "azurerm_role_definition" "blobrw" {
  name  = "access-to-azure-blob"
  scope = data.azurerm_subscription.primary.id

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    ]
    not_actions = []
    not_data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
    ]
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}",
  ]
}

#resource "azurerm_role_assignment" "blobrw_assignment" {
#  scope              = data.azurerm_subscription.primary.id
#  role_definition_id = azurerm_role_definition.blobrw.role_definition_resource_id #.id
#  principal_id       = data.azurerm_client_config.current.object_id
#}


resource "azurerm_role_assignment" "blobrw_assignment" {
  scope = data.azurerm_subscription.primary.id
  #role_definition_id = azurerm_role_definition.blobrw.id
  # ERROR: id is appended with /subscription...
  #role_definition_id  = "/subscriptions/ba11dd43-5df0-464d-868f-fd3a7503e680/providers/Microsoft.Authorization/roleDefinitions/9b36815e-eefc-b01f-2944-9f5bc0ddeef1|/subscriptions/ba11dd43-5df0-464d-868f-fd3a7503e680"
  # BUG FOUND https://github.com/terraform-providers/terraform-provider-azurerm/issues/8426
  #role_definition_id = "/subscriptions/ba11dd43-5df0-464d-868f-fd3a7503e680/providers/Microsoft.Authorization/roleDefinitions/9b36815e-eefc-b01f-2944-9f5bc0ddeef1"
  role_definition_name = azurerm_role_definition.blobrw.name
  principal_id         = azurerm_linux_virtual_machine.demo-instance.identity.0.principal_id
}
