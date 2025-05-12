variable "public_key" {
  
}
variable "security_group_vpc_id" {
  
}
variable "ingress_rules" {
  description = "List of ingress rules (port + cidr)"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
}
variable "env" {
  
}
variable "ec2_name_tag" {
  
}
variable "instance_type" {
  
}
variable "ec2_subnet_id" {
  
}
variable "ami" {
  
}
variable "key_name" {
  
}
