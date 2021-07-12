# TODO: define subnets in-line within the network resource
resource "azurerm_virtual_network" "demo-virtual-network" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-subnet-1" {
  name                 = "${var.prefix}-internal-1"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo-virtual-network.name
  address_prefixes     = ["10.0.0.0/24"]
}

# TODO: add azurerm_application_security_group
resource "azurerm_network_security_group" "demo-nsg" {
  name                = "${var.prefix}-instance-nsg"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
  }
}
