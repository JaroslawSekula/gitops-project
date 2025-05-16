terraform {
    source = "../../../../modules/private_vpc"
}

locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
    env = local.region_vars.inputs.env
    vpc_cidr_block      =      "10.1.0.0/16"
    subnet_cidr_block   =      "10.1.1.0/24"
    private_subnet_cidr =      "10.1.2.0/24"
    alb_subnet_cidr = "10.1.10.0/26"
}
