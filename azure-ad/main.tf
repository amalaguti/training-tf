terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.64.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=0.7"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
    virtual_machine_scale_set {
      force_delete                 = true # Default: true
      roll_instances_when_required = true # Default: true
    }
  }
  subscription_id = var.subscription_id
}
