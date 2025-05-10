dependency "shared_vpc"{
    config_path = "../../../shared/us-east-1/vpc"
    mock_outputs = {
        vpc_id = "mock_vpc_587436"
        route_table_id = "mock_route_table_346743"
        vpc_cidr = "mock_vpc_cidr_474843"
    }
}
dependency "dev_vpc"{
    config_path = "../vpc"
    mock_outputs = {
        vpc_id = "mock_vpc_287374"
        route_table_id = "mock_route_table_28384"
        vpc_cidr = "mock_vpc_cidr_93842"
    }
}

terraform {
    source = "../../../../modules/peering"
}

inputs = {
    vpc_id = dependency.dev_vpc.outputs.vpc_id
    peer_vpc_id = dependency.shared_vpc.outputs.vpc_id

    vpc_route_table_id = dependency.dev_vpc.outputs.private_route_table_id
    peer_route_table_id = dependency.shared_vpc.outputs.route_table_id

    vpc_cidr_block = dependency.dev_vpc.outputs.vpc_cidr
    peer_cidr_block = dependency.shared_vpc.outputs.vpc_cidr
}