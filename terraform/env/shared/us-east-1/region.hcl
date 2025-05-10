locals {
  region   = "us-east-1"
  env = "shared"
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

