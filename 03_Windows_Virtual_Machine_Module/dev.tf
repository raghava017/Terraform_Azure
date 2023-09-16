module "module_dev" {
    source = "./modules"
    prefix = "dev"
    vnet_cidr_prefix = "10.20.0.0/16"
    subnet1_cidr_prefix = "10.20.1.0/24"
    rgname = "DevRG" 
    subnet = "DevSubnet"
    rglocation = "eastus"
    computer_name = "dev-vm"
    admin_username = "adminuser123"
    admin_passwd   = "Password@1234"
}