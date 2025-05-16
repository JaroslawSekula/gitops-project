resource "aws_key_pair" "key" {
  key_name = "bastion-key"
  public_key = file("../../ssh/bastion-key.pub")
}