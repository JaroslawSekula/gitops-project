locals {
  region   = "us-east-1"
  env = "stage"
  key_name = "bastion-key"
}

dependencies {
    paths = [
        "${get_repo_root()}/terraform/env/shared/key",
        "${get_repo_root()}/terraform/env/shared/backend"

    ]
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
    key_name = local.key_name
    region = local.region
    ami = "ami-0f88e80871fd81e91"
    public_key_path = file("${get_repo_root()}/ssh/public/bastion-key.pub")
    public_ip = true
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