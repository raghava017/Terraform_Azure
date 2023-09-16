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
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "20000000-0000-0000-0000-000000000000"
  tenant_id       = "10000000-0000-0000-0000-000000000000"
  subscription_id = "20000000-0000-0000-0000-000000000000"
}


terraform {
  backend "azurerm" {
    storage_account_name = "tfstorageacc16"
    container_name       = "tfstate1"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "abcdefghijklmnopqrstuvwxyz0123456789gajhujahfhjdhhdsgdjhsgchghbdjfg=="
  }
}


# Create a Resource Group

resource "azurerm_resource_group" "tf-test" {
    name          = "${var.rgname}"
    location      = "${var.rglocation}"
}

# Create a Virtual Network within the Resource group

resource "azurerm_virtual_network" "tf-test" {
    name                  = "${var.prefix}-net123"
    resource_group_name   = "${azurerm_resource_group.tf-test.name}"
    location              = "${azurerm_resource_group.tf-test.location}"
    address_space         = ["${var.vnet_cidr_prefix}"]
}

# Create a Subnet with in the Virtual network

resource "azurerm_subnet" "tf-test" {
    name                  = "${var.prefix}-subnet"
    resource_group_name   = "${azurerm_resource_group.tf-test.name}"
    virtual_network_name  = "${azurerm_virtual_network.tf-test.name}"
    address_prefixes      = ["${var.subnet1_cidr_prefix}"]
}

# Create a Network interface card with in the subnet

resource "azurerm_network_interface" "tf-test" {
    name                = "${var.prefix}-nic"
    location            = "${azurerm_resource_group.tf-test.location}"
    resource_group_name =  "${azurerm_resource_group.tf-test.name}"

    ip_configuration {
      name = "internal"
      subnet_id = "${azurerm_subnet.tf-test.id}"
      private_ip_address_allocation = "Dynamic"
    }

}
