locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

dependency "app" {
    config_path = "../app"
    mock_outputs = {
        id = "mock-app-id-284284"
    }
}
dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        subnet_ids = ["3852772", "3842857"]
        vpc_id = "382757"
    }

    }

terraform {
    source = "../../../../modules/alb"
}

include {
  path = find_in_parent_folders("region.hcl")
}

inputs = {
    env = local.region_vars.inputs.env
    vpc_id = dependency.vpc.outputs.vpc_id
    alb_public_subnets = dependency.vpc.outputs.subnet_ids
    instance_app_id = dependency.app.outputs.id
}