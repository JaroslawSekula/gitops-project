dependencies {
    paths = [
        "../../../shared/backend",
        "../../../dev/us-east-1/alb"
    ]
}

dependency "profile" {
    config_path = "../../policies/bastion"
}
dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        vpc_id = "mock_vpc_38482"
        subnet_id = "mock_subnet_284339"
    }
}
locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

terraform {
    source = "../../../../modules/bastion"
}

include {
  path = find_in_parent_folders("region.hcl")
}

inputs = {
    security_group_vpc_id = dependency.vpc.outputs.vpc_id
    ec2_subnet_id = dependency.vpc.outputs.subnet_id
    key_name = local.region_vars.inputs.key_name
    instance_type = "t2.micro"
    ec2_name_tag = "bastion"
    ami = local.region_vars.inputs.ami
    env = local.region_vars.inputs.env
    instance_profile = dependency.profile.outputs.profile
}