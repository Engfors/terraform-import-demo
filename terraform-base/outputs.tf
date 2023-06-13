output "vault" {
  value = hcp_vault_cluster.vault
  sensitive = true
}

output "hcp_vault_cluster_admin_token" {
  value = hcp_vault_cluster_admin_token.token
  sensitive = true
}

output "vault_url" {
  value = data.hcp_vault_cluster.vault.public_endpoint ? (
    data.hcp_vault_cluster.vault.vault_public_endpoint_url
    ) : (
    data.hcp_vault_cluster.vault.vault_private_endpoint_url
  )
  description = "HCP Vault UI"
}
