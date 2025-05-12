locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependencies {
    paths = [
        "../../../shared/backend",
        "../../../shared/us-east-1/bastion"
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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRnvvMcd5g4f1ImzvopdyvvEsGvjIGUuagPvlMYsMrhFFaTDMYNpNeuGs1iq2kGseOWSHdbo3Ks2EQwKIGwU+1XFDeksmnIzNk3zHLsJ+LyzQ7C14BjiZRkpGF78xksdo0ITMcAxkXXDw9ioveNQbXmt7TzeBNjQhUNQyT7r/vWGkGLcWYAeGZ3jfcHbTl+0wIXtj++/mzJaWH5yCl7XH1ZxKHtJ0AVTKlf2LQivSONKZGo+Ho1hVlC0auV/L7Mqs2KIGt9mxStYSRrEFk2ycioPkmQbaMovjb8BN9HQoZ0Xu6tR3i2rEGLKqdjvEHedvssPaFf8Fyzkzoagk7RVjtTp5NCSxLGXRO6WX2Xw0Zs1eqxP0U0MjuAfx+TdjUM0J8WnD+CD6S7Pyr4IMhLh6SZjCqEfc20RtFDx2T9Nu/NCUIPJ9c77rh3xoBhTVe0b50oQbDl5R9QZIA2gdSTzlFeuKJ78LcG1R9qjBuEgjsScct2sexOwk/EHQUa01RR05CIW1Mt+aVm99t/M0s/sxBicTvLd+0fu14ZWlhnPN7/sVftbfhRk7uNwMs0g8jyIp/dJQSKDON6db2hjx465pPp5rLn4iTChiFZBlyHalPJZX5v9Bp/KzVtFuG2JGTwiQTNF0vAb409EeSz/TpHcfh2fNftw1GvpnmhCVd3Ss5Lw== tf@DESKTOP-2Q2BIEE"
    security_group_vpc_id = dependency.vpc.outputs.vpc_id
    ec2_subnet_id = dependency.vpc.outputs.private_subnet_id
    instance_type = "t2.micro"
    ec2_name_tag = "database"
    ingress_rules = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr = dependency.shared_vpc.outputs.vpc_cidr
        },
        {
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            cidr = dependency.vpc.outputs.vpc_cidr
        }
    ]
    ami = local.region_vars.inputs.ami
    env = local.region_vars.inputs.env
    key_name = local.region_vars.inputs.key_name
}