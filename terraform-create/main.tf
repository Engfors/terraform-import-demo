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

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_backend_v2" "example" {
  mount                = vault_mount.kvv2.path
  max_versions         = 5
  delete_version_after = 12600
  cas_required         = false
}

resource "vault_kv_secret_v2" "example" {
  mount               = vault_mount.kvv2.path
  name                = "secret"
  delete_all_versions = true
  data_json = jsonencode(
    {
      imported  = "false",
      terraform = "1.5.0"
    }
  )
  custom_metadata {
    max_versions = 10
    data = {
      demo   = "true"
    }
  }
}
