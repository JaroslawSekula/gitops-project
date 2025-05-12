terraform {
    source = "../../../../modules/vpc"
}

locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
    env = local.region_vars.inputs.env
    vpc_cidr_block = "10.1.0.0/16"
    subnet_cidr_block = "10.1.1.0/24"
    key_name = local.region_vars.inputs.key_name
}
