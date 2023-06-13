variable "region" {
  type        = string
  description = "Resource region"
  default     = "eu-west-2"
  validation {
    condition = contains([
      "us-east-1", "us-east-2", "us-west-2", "ca-central-1",
      "eu-west-1", "eu-west-2", "eu-central-1",
      "ap-northeast-1", "ap-southeast-1", "ap-southeast-2"
    ], var.region)
    error_message = "Region must be a valid one for HCP."
  }
}

variable "hcp_network_cidr_block" {
  type        = string
  description = "HCP CIDR Block for HashiCorp Virtual Network. Must be different than `peering vpc`."
  default     = "10.10.16.0/20"
}

variable "public_endpoint" {
  type = bool
  description = "Denotes that the cluster has a public endpoint. Defaults to true for demo purposes, do not enable this by default in production."
  default = true
}

variable "hcp_consul_tier" {
  type        = string
  description = "Tier for HCP Consul cluster."
  default     = "development"
  validation {
    condition = contains([
      "development", "standard", "plus"
    ], var.hcp_consul_tier)
    error_message = "Tier must be a valid one for HCP Consul."
  }
}

variable "hcp_vault_tier" {
  type        = string
  description = "Tier for HCP Vault cluster."
  default     = "dev"
  validation {
    condition = contains([
      "dev", "standard_small", "standard_medium", "standard_large", "starter_small"
    ], var.hcp_vault_tier)
    error_message = "Tier must be a valid one for HCP Vault."
  }
}

variable "hcp_consul_datacenter" {
  type        = string
  description = "Datacenter for HCP Consul cluster. Must be `dc1` to work with ECS modules."
  default     = "dc1"
}
