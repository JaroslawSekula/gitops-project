terraform {
    source = "../../../modules/backend"
}

dependencies {
    paths = [
        "${get_repo_root()}/terraform/env/shared/key"
    ]
}

inputs = {
    ssh_private_key_path = "${get_repo_root()}/ssh/private/bastion-key"
}