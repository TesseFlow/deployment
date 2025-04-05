terraform {
  required_version = "~>1.11.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.7.0"
    }
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}
