dependencies {
    paths = [
        "../../../shared/backend",
        "../../../stage/us-east-1/alb"
    ]
}

dependency "profile" {
    config_path = "../../policies/bastion"
    mock_outputs = {
        profile = "mock-profile"
    }
}
dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        subnet_id = "mock-subnet-id"
        vpc_output = "mock-vpc-output"
        private_subnet_id = "4739385"
        vpc_cidr = "0.0.0.0/0"
        vpc_id = "382757"
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