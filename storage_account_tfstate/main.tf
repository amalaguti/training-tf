terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.64.0"
    }
  }
  # Run first, to create RG
  # then enable backend
  #backend "azurerm" {
  #  resource_group_name  = "demo-tfstate"
  #  storage_account_name = "sankedgxvt"
  #  container_name       = "tfstate"
  #  key                  = "terraform.tfstate"
#}
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
