# demo instance
resource "azurerm_linux_virtual_machine" "demo-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo-instance.id]
  size                  = "Standard_A1_v2"
  admin_username        = "demo"

  # CRITICAL: Set VM Identity
  # https://www.meik.org/2019/01/09/access-azures-blob-storage-with-curl-on-an-vmvmss-instance/
  # A system assigned managed identity enables Azure resources to authenticate
  # to cloud services without storing credentials in code.
  # Once enabled, all necessary permissions can be granted
  # via Azure role-based-access-control (IAM).
  identity {
    type = "SystemAssigned"
  }
  # This allows to equest an access token with an HTTP REST call.
  # Before we do so, we need to authorize our vm to access the storage
  # container where the Kubernetes configuration lives on.
  # This is done through role-based access control (RBAC).
  # Azure Storage defines a set of built-in RBAC roles that encompass
  # common sets of permissions.
  # Go to your storage account resource and choose Access control (IAM).
  # Click on Add role assignment

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
    public_key = file(pathexpand("~/Desktop/awskeys/tf-training.pub"))
  }
}

resource "azurerm_network_interface" "demo-instance" {
  name                = "${var.prefix}-instance1"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  #network_security_group_id  = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-instance.id
  }
}

resource "azurerm_public_ip" "demo-instance" {
  name                = "instance1-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Dynamic"
}
