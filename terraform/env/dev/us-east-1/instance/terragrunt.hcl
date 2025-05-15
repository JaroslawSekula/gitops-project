locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        vpc_output = "mock-vpc-output"
        private_subnet_id = "4739385"
        vpc_cidr = "0.0.0.0/0"
        vpc_id = "382757"
    }
}
dependency "shared_vpc" {
    config_path = "../../../shared/${local.region_vars.inputs.region}/vpc"
    mock_outputs = {
        vpc_output = "mock-vpc-output"
        private_subnet_id = "4739385"
        vpc_cidr = "0.0.0.0/0"
        vpc_id = "382757"
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
}