terraform {
  cloud {
    organization = "<CHANGE ME>"
    workspaces {
      tags = ["demo", "import"]
    }
  }
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.60.0"
    }
  }
  required_version = "1.5.0"
}
