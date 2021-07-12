resource "azurerm_linux_virtual_machine_scale_set" "demo" {
  name                = "mytestscaleset-1"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  admin_username      = "demo"
  instances           = 2
  sku                 = "Standard_A1_v2"

  admin_ssh_key {
    username   = "demo"
    public_key = file("/Users/amalaguti/Desktop/awskeys/tf-training.pub")
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
  custom_data          = base64encode("#!/bin/bash\n\napt-get update && apt-get install -y nginx && systemctl enable nginx && systemctl start nginx")

  upgrade_mode = "Automatic"
  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }
  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.demo.id

  automatic_os_upgrade_policy {
    disable_automatic_rollback  = true
    enable_automatic_os_upgrade = true
  }

  zones = var.zones

  network_interface {
    name                      = "networkprofile"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.demo-nsg.id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.demo-subnet-1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }
}
