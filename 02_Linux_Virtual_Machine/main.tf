terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {} 
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "20000000-0000-0000-0000-000000000000"
  tenant_id       = "10000000-0000-0000-0000-000000000000"
  subscription_id = "20000000-0000-0000-0000-000000000000"
}


resource "azurerm_resource_group" "example" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  address_space       = ["${var.vnet_cidr_prefix}"]
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
}

resource "azurerm_subnet" "example" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.example.name}"
  virtual_network_name = "${azurerm_virtual_network.example.name}"
  address_prefixes     = ["${var.subnet1_cidr_prefix}"]

  depends_on = [ 
    azurerm_virtual_network.example
   ]

}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.example.id}"
  }
  depends_on=[
      azurerm_network_security_group.example,
      azurerm_subnet.example,
      azurerm_public_ip.example,
      ]
}

resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}-pip"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  allocation_method   = "Dynamic"
  depends_on = [ 
    azurerm_resource_group.example
   ]
}

resource "azurerm_network_security_group" "example" {
  name                  =   "${var.prefix}-nsg"
  location              =   "${azurerm_resource_group.example.location}"
  resource_group_name   =   "${azurerm_resource_group.example.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "ubuntu-vm"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  size                 = "Standard_B1s"
  admin_username       = "${var.admin_username}"
  admin_password       = "${var.admin_passwd}"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.example.id]

    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  #source_image_reference {
    #publisher = "Canonical"
   # offer     = "UbuntuServer"
   # sku       = "20_04-LTS"
   # version   = "latest"
 # }


# https://github.com/hashicorp/terraform-provider-azurerm/issues/22078
# The above  page is  reference for linux source image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
}

  depends_on = [ 
    azurerm_network_interface.example
   ]

}
