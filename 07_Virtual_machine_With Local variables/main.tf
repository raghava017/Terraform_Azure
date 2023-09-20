# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
provider "azurerm" {
  features {} 
  # client_id       = "84dea408eb634524ba7793ade13c17fa"
  # client_secret   = "84dea408eb634524ba7793ade13c17fa"
  # tenant_id       = "84dea408eb634524ba7793ade13c17fa"
  # subscription_id = "84dea408eb634524ba7793ade13c17fa"
}


locals {
  rg_info       = azurerm_resource_group.example.name
  rg_location   = azurerm_resource_group.example.location
  vnet_name     = azurerm_virtual_network.example.name

}

resource "azurerm_resource_group" "example" {
    name                = "${var.rgname}"
    location            = "${var.location}"
  
    tags = {
      Environment = "test"
    }
}

resource "azurerm_virtual_network" "example" {
    name                           = "test-vnet"
    resource_group_name            = local.rg_info
    location                       = local.rg_location
    address_space                  = ["${var.vnet_cidr_prefix}"] 
  
}

resource "azurerm_subnet" "example" {
    name                            = "${var.prefix}-subnet"
    virtual_network_name            = local.vnet_name
    resource_group_name             = local.rg_info
    address_prefixes                = ["${var.subnet1_cidr_prefix}"]
  
}

resource "azurerm_public_ip" "example" {
  name                          = "${var.prefix}-pip"
  location                      = local.rg_location
  resource_group_name           = local.rg_info
  allocation_method             = "Dynamic"
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.prefix}-nsg"
  location            = local.rg_location
  resource_group_name = local.rg_info

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = local.rg_location
  resource_group_name = local.rg_info

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation= "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }

  depends_on=[
      azurerm_network_security_group.example,
      azurerm_subnet.example,
      azurerm_public_ip.example,
      ]
}

resource "azurerm_windows_virtual_machine" "example" {
  name                  = "${var.prefix}-VM"
  location              = local.rg_location
  size                  = "Standard_B1s"
  resource_group_name   = local.rg_info
  network_interface_ids =[azurerm_network_interface.example.id]
  
   os_disk {
    caching              ="ReadWrite"
    storage_account_type ="Standard_LRS"
   }

   source_image_reference {
     publisher ="MicrosoftWindowsServer"
     offer     ="WindowsServer"
     sku       ="2019-Datacenter"
     version   ="latest"
   }

   computer_name="myvm"

   admin_username="adminuser"

   admin_password="Password1234!"

}
