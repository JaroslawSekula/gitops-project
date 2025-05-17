resource "aws_key_pair" "key" {
  key_name = "bastion-key"
  public_key = var.public_key_path
}