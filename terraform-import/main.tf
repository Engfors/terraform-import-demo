data "terraform_remote_state" "base" {
  backend = "remote"

  config = {
    organization = "<CHANGE ME>"
    workspaces = {
      name = "terraform_import_base"
    }
  }
}

provider "vault" {
  address = data.terraform_remote_state.base.outputs.vault.vault_public_endpoint_url
  token   = data.terraform_remote_state.base.outputs.hcp_vault_cluster_admin_token.token
}
