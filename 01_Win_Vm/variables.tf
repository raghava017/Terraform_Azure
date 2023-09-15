variable "rgname" {
    type = string
    description = "used for naming resource group"
  
}

variable "rglocation" {
    type = string
    description = "used for selecting the location"
    default = "East us"
  
}

variable "prefix" {
    type = string
    description = "used to define a standard prefix for all resources"
  
}

variable "vnet_cidr_prefix" {
    type = string
    description = "this variable defines address space for vnet"
  
}

variable "subnet1_cidr_prefix" {
    type = string
    description = "this variable defines address space for subnet"
  
}

variable "admin_username" {
    type = string
    description = "provide a username"
    default = "adminuser"
  
}

variable "admin_passwd" {
    type = string
    description = "provide a  unique password"
    default = "Password@1234"
  
}