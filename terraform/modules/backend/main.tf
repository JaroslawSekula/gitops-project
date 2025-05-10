resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-state-gitops-project"
  force_destroy = true
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_ssm_parameter" "ssh_private_key" {
  name = "ssh_private_key"
  type = "SecureString"
  value = file(var.ssh_private_key_path)
}