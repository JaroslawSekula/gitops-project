resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true
}

resource "aws_route" "vpc_route" {
  route_table_id = var.vpc_route_table_id
  destination_cidr_block = var.peer_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "peer-vpc-route" {
  route_table_id = var.peer_route_table_id
  destination_cidr_block = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}