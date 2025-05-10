terraform {
    source = "../../../modules/backend"
}

inputs = {
    ssh_private_key_path = "${get_repo_root()}/ssh/private/bastion-key"
}