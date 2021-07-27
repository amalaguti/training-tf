resource "azurerm_linux_virtual_machine_scale_set" "demo" {
  name                = "mytestscaleset-1"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  admin_username      = "demo"
  instances           = 2
  sku                 = "Standard_A1_v2"

  admin_ssh_key {
    username   = "demo"
    public_key = file(pathexpand("~/Desktop/awskeys/tf-training.pub"))
  }
  disable_password_authentication = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  computer_name_prefix = "demo"
  #custom_data          = base64encode("#!/bin/bash\n\napt-get update && apt-get install -y nginx && systemctl enable nginx && systemctl start nginx")
  #custom_data replaced by extension

  upgrade_mode = "Manual"
  # With upgrade_mode = "Manual":
  #   rolling_upgrade_policy not required
  #   automatic_os_upgrade_policy not required
  #   health_probe_id not required


  extension {
    name                 = "InstallCustomScript"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings             = <<SETTINGS
        {
          "fileUris": ["https://raw.githubusercontent.com/in4it/terraform-azure-course/master/application-gateway/install_nginx.sh"],
          "commandToExecute": "./install_nginx.sh"
        }
      SETTINGS
  }


  network_interface {
    name                                     = "networkprofile"
    primary                                  = true
    network_security_group_id                = azurerm_network_security_group.allow-ssh.id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.demo-subnet-2.id
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.app-gateway.backend_address_pool.0.id]
    }
  }
}
