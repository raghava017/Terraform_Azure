module "module_dev" {
    source = "./modules"
    prefix = "qa"
    vnet_cidr_prefix = "20.20.0.0/16"
    subnet1_cidr_prefix = "20.20.1.0/24"
    rgname = "qaRG" 
    subnet = "qaSubnet"
    rglocation = "westus"  
}