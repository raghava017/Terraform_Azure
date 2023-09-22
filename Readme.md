## What is Terraform?
Terraform is an infrastructure as a code (IAC) tool that allows you to build, change, and version infrastructure safely and efficiently.

HashiCorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle. Terraform can manage low-level components like compute, storage, and networking resources, as well as high-level components like DNS entries and SaaS features.

Terraform Supports all clouds such as Azure, GCP, AWS, VM ware and etc.

## Advantages of Terraform
1.	Repeatability
2.	Speed
3.	Documentation
4.	Version Control 
5.	Validation 
6.	Reuse

## How does Terraform work?

Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs). Providers enable Terraform to work with virtually any platform or service with an accessible API.

HashiCorp and the Terraform community have already written thousands of providers to manage many different types of resources and services. You can find all publicly available providers on the Terraform Registry, including Amazon Web Services (AWS), Azure, Google Cloud Platform (GCP), Kubernetes, Helm, GitHub, Splunk, DataDog, and many more.

## The core Terraform workflow consists of three stages:

## Write: 

You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (Vnet) network with security groups and a load balancer.

## Plan:

Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.

## Apply: 

On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a Vnet and change the number of virtual machines in that Vnet, Terraform will recreate the Vnet before scaling the virtual machines.

## Why Terraform?

Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs). Providers enable Terraform to work with virtually any platform or service with an accessible API and Terraform solves infrastructure challenges.




## Components of Terraform:
1.	Providers
2.	Resources
3.	Variables
4.	Statefile
5.	Provisioners
6.	Backends
7.	Modules
8.	Data Sources
9.	Service Principles

## Providers:

Terraform Relies on plugins called “ providers” to interact with cloud providers, SaaS providers, and other APIs.

## provider  for Azure Cloud

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

## Resources:
Resources are the most important element in the terraform language. Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records.

## Resource Example

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

## Variables
Using Variables in terraform configurations makes our deployment more dynamic.
A separate file with the name “variables.tf” needs to be created in the working directory to store all variables for our used in main.tf configuration file.

## Variable Example 

variable "rgname" {
    type = string
    description = "used for naming resource group"
  
}

variable "rglocation" {
    type = string
    description = "used for selecting the location"
    default = "East us"
  
}

## Statefile:

After the deployment is finished terraform creates a state file to keep track of the current state of the infrastructure.
It will use this file to compare when you deploy/destroy resources, in other words, it compares the “current state” with the “desired state” using this file.
A file with the name “terraform.tfstate” will be created in your working directory.

## Provisioners

Provisioners provide the ability to run additional steps or tasks when a resource is created or destroyed.
This is not a replacement for configuration management tools.

## Provisioners example

provisioner "file" {
    source      = "./script.ps1"
    destination = "C:/temp/setup.ps1"

    connection {
        type        ="winrm"
        user        ="Administrator"
        password    = "Password@1234!"
        host        = "server1"
    }
}

## Backend 
A backend defines where Terraform stores its state data files. Terraform uses persisted state data to keep track of the resources it manages. Most non-trivial Terraform configurations either integrate with Terraform Cloud or use a backend to store state remotely.

## Example for Backend 
When authenticating using the Access Key associated with the Storage Account:

data "terraform_remote_state" "foo" {
  backend = "azurerm"
  config = {
    storage_account_name = "terraform123abc"
    container_name       = "terraform-state"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "abcdefghijklmnopqrstuvwxyz0123456789..."
  }


## Terraform Modules:

if you want to perform a template-based deployment you can follow modularized apprpach.

A module defines a set of parameters which will be passed as key value pairs to actual deployment.

with this approach you can create a multiple environmet in a very easy way.

## Data Source 

if you deploy your resources out of terraform and use them in your terraform code the way you use them through "Data Sources"

Data Sources in Terraform are used to get information about resources external to terraform, and use them to setup your terraform resources.

## Example Data source Module

# Get Resources from a Resource Group
data "azurerm_resources" "example" {
  resource_group_name = "example-resources"
}

# Get Resources with specific Tags
data "azurerm_resources" "example" {
  resource_group_name = "example-resources"

  required_tags = {
    environment = "production"
    role        = "webserver"
  }
}

## Terraform local variables:

Terraform Locals are named values that can be assigned and used in your code. It mainly serves the purpose of reducing duplication within the Terraform code. When you use Locals in the code, since you are reducing duplication of the same value, you also increase the readability of the code.

## example local varibales blocks

locals {
  rg_info       = azurerm_resource_group.example.name
  rg_location   = azurerm_resource_group.example.location
  vnet_name     = azurerm_virtual_network.example.name

}

resource "azurerm_virtual_network" "example" {
    name                           = "test-vnet"
    resource_group_name            = local.rg_info
    location                       = local.rg_location
    address_space                  = ["${var.vnet_cidr_prefix}"] 
  
}

## most used terraform commands 

terraform init { initializes a working directory containing Terraform configuration files}

terraform validate {This commands main goal is validating syntax. }

terraform plan {creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure} 

terraform apply {Creates or updates infrastructure depending on the configuration files.}

terraform apply --auto-approve {Skips interactive approval of plan before applying}

terraform destroy {terminates resources managed by your Terraform project}


## commands for Terraform Workspaces:
4 main workspace commands 
1. Terraform workspace list  {to list the workspaces}
2. Terraform workspace new <name of workspace >

Ex:  terraform workspace new dev 

Ex:  terraform workspace new prod

3. Terraform workspace select dev {for switch the workspace }

4. Terraform workspace show {List out the work spaces}

5. Terraform apply -var-file dev.tfvars  {for dev}

6. Terraform apply -var-file prod.tfvars  {for prod}
