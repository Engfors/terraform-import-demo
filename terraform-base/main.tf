resource "hcp_hvn" "hvn" {
  hvn_id         = "import-demo"
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = var.hcp_network_cidr_block
}

resource "hcp_vault_cluster" "vault" {
  hvn_id          = hcp_hvn.hvn.hvn_id
  cluster_id      = "import-demo-vault"
  tier            = var.hcp_vault_tier
  public_endpoint = var.public_endpoint
}

resource "hcp_vault_cluster_admin_token" "token" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
}
