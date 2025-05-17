output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnet_id" {
  value = aws_subnet.subnet.id
}
output "subnet_ids" {
  value = [
    aws_subnet.subnet.id,
    aws_subnet.private_subnet.id
   ]
}
output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}
output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}
