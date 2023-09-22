variable "rgname" {
    type = string
    description = "Provide name for the  Resource Group"
}

variable "rglocation" {
    type = string
    description = "Provide Location for  The Resource Group"
}

variable "vnet_name" {
    type = string
    description = "Provide Location for  The Resource Group"
}

variable "vnet_cidr_prefix" {
    type = string
    description = "this variable defines address space for vnet"
  
}

variable "subnet_name" {
    type = string
    description = "Provide a name for the Subnet"
  
}

variable "subnet_cidr_prefix" {
    type = string
    description = "this variable defines address space for subnet"
  
}