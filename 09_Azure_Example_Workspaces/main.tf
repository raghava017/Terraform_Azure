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
  #client_id       = "***************************************"
  #client_secret   = "***************************************"
  #tenant_id       = "***************************************"
  #subscription_id = "***************************************"
}

resource "azurerm_resource_group" "example" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.vnet_name}"
  address_space       = ["${var.vnet_cidr_prefix}"]
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
}

resource "azurerm_subnet" "example" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${azurerm_resource_group.example.name}"
  virtual_network_name = "${azurerm_virtual_network.example.name}"
  address_prefixes     = ["${var.subnet_cidr_prefix}"]

  depends_on = [ 
    azurerm_virtual_network.example
   ]

}

