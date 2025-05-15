dependency "shared_vpc"{
    config_path = "../../../shared/us-east-1/vpc"
    mock_outputs = {
        shared_vpc_output = "mock-shared_vpc-output"
        vpc_id = "995764"
        route_table_id = "9957657"
        vpc_cidr = "0.0.0.0/0"
    }
}
dependency "dev_vpc"{
    config_path = "../vpc"
    mock_outputs = {
        vpc_id = "995765"
        route_table_id = "995765"
        vpc_cidr = "0.0.0.0/0"
    }
}

terraform {
    source = "../../../../modules/peering"
}

inputs = {
    vpc_id = dependency.dev_vpc.outputs.vpc_id
    peer_vpc_id = dependency.shared_vpc.outputs.vpc_id

    vpc_route_table_id = dependency.dev_vpc.outputs.route_table_id
    peer_route_table_id = dependency.shared_vpc.outputs.route_table_id

    vpc_cidr_block = dependency.dev_vpc.outputs.vpc_cidr
    peer_cidr_block = dependency.shared_vpc.outputs.vpc_cidr
}