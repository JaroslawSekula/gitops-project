terraform {
    source = "../../../modules/key"
}

inputs = {
    public_key_path = file("${get_repo_root()}/ssh/public/bastion-key.pub")
}