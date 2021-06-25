resource "azurerm_resource_group" "demo" {
  name     = var.prefix
  location = var.location
  tags = {
    env   = "training"
    owner = "adrian"
  }
  timeouts {
    create = "2h"
    delete = "90m"
  }
}
