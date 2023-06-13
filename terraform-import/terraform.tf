terraform {
  cloud {
    organization = "<CHANGE ME>"
    workspaces {
      tags = ["demo", "import"]
    }
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.16.0"
    }
  }
  required_version = "1.5.0"
}
