# demo instance
resource "azurerm_linux_virtual_machine" "demo-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo-instance-1.id]
  size                  = "Standard_A1_v2"
  admin_username        = "demo"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "myosdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "demo"
    public_key = file("/Users/amalaguti/Desktop/awskeys/tf-training.pub")
  }
}

resource "azurerm_network_interface" "demo-instance-1" {
  name                = "${var.prefix}-instance1"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  # from terraform-provider-azurerm >2.0 we need to put this in a seperate resource
  # see azurerm_network_interface_security_group_association below
  # network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-instance-1.id
  }
}

resource "azurerm_network_interface_security_group_association" "demo-instance-1" {
  network_interface_id      = azurerm_network_interface.demo-instance-1.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id
}


resource "azurerm_public_ip" "demo-instance-1" {
  name                = "instance1-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Dynamic"
}

resource "azurerm_application_security_group" "demo-instance-group" {
  name                = "internet-facing"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_network_interface_application_security_group_association" "demo-instance-group" {
  network_interface_id          = azurerm_network_interface.demo-instance-1.id
  application_security_group_id = azurerm_application_security_group.demo-instance-group.id
}

# demo instance 2
resource "azurerm_linux_virtual_machine" "demo-instance-2" {
  name                  = "${var.prefix}-vm-2"
  location              = var.location
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo-instance-2.id]
  size                  = "Standard_A1_v2"
  admin_username        = "demo"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "myosdisk2"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "demo"
    public_key = file("/Users/amalaguti/Desktop/awskeys/tf-training.pub")
  }
}

resource "azurerm_network_interface" "demo-instance-2" {
  name                = "${var.prefix}-instance2"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  # from terraform-provider-azurerm >2.0 we need to put this in a seperate resource
  # see azurerm_network_interface_security_group_association below
  # network_security_group_id = azurerm_network_security_group.internal-facing.id

  ip_configuration {
    name                          = "instance2"
    subnet_id                     = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "demo-instance-2" {
  network_interface_id      = azurerm_network_interface.demo-instance-2.id
  network_security_group_id = azurerm_network_security_group.internal-facing.id
}
