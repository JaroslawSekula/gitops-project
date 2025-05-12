locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependency "profile" {
    config_path = "../../policies/app"
}

dependencies {
    paths = [
        "../../../shared/backend",
        "../database",
        "../rabbitmq",
        "../memcache"
    ]
}
dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        vpc_id = "mock_vpc_293845"
        subnet_id = "mock_subnet_294853"
    }
}
dependency "shared_vpc" {
    config_path = "../../../shared/${local.region_vars.inputs.region}/vpc"
    mock_outputs = {
        vpc_cidr = "mock_vpc_cidr_2938472"
    }
}

terraform {
    source = "../../../../modules/ec2"
}

include {
  path = find_in_parent_folders("region.hcl")
}

inputs = {
    security_group_vpc_id = dependency.vpc.outputs.vpc_id
    ec2_subnet_id = dependency.vpc.outputs.private_subnet_id
    instance_type = "t2.small"
    ec2_name_tag = "app"
    ingress_rules = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr = dependency.shared_vpc.outputs.vpc_cidr
        },
        {
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr = "0.0.0.0/0"
        }
    ]
    ami = local.region_vars.inputs.ami
    env = local.region_vars.inputs.env
    key_name = local.region_vars.inputs.key_name
    instance_profile = dependency.profile.outputs.profile
}