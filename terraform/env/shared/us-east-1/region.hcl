locals {
  region   = "us-east-1"
  env = "shared"
  key_name = "bastion-key"
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
        provider "aws" {
            region = "${local.region}"
        }
    EOF
}

inputs = {
    env = local.env
    region = local.region
    ami = "ami-0f88e80871fd81e91"
    key_name = local.key_name
    public_key_path = file("${get_repo_root()}/ssh/public/bastion-key.pub")

}

remote_state {
    backend = "s3"
    generate = {
        path = "backend.tf"
        if_exists = "overwrite"
    }
    config = {
        bucket         = "terraform-state-gitops-project"
        key            = "${local.env}/${local.region}/${path_relative_to_include()}/terraform.tfstate"
        region         = local.region
        dynamodb_table = "terraform-lock-table"
        encrypt        = true
    }
}

