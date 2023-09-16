module "module_dev" {
    source = "./modules"
    prefix = "prod"
    vnet_cidr_prefix = "10.70.0.0/16"
    subnet1_cidr_prefix = "10.70.1.0/24"
    rgname = "prodRG" 
    subnet = "prodSubnet"
    rglocation = "centralus"  
}