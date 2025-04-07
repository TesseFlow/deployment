provider "vault" {
  # Use the folowwing environment variables for confiration
  # VAULT_ADDR -> vault server address
  # VAULT_TOKEN -> vault authorization token
  # VAULT_CACERT -> path to server validate certificate file
}

data "vault_kv_secret_v2" "creds" {
  mount = var.vault_secret_path
  name  = var.vault_secret_kv_path
}

locals {
  creds         = data.vault_kv_secret_v2.creds.data
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = var.proxmox_api_url
  pm_user         = local.creds.proxmox_user
  pm_password     = local.creds.proxmox_pass
}

module "proxmox" {
  source = "./modules/proxmox"

  # override these values in main_override.tf

  pool_name       = "VALUE"
  vms_prefix      = "VALUE"

  vms_sshkeys     = "VALUE"

  vms_ci_storage  = "VALUE"

  vms = [
    {
      role      = "VALUE"
      desc      = "VALUE"
      tags      = [ "VALUE" ]
      memory    = 0
      cpu       = 0
      ipconfig  = "VALUE"
      template  = "VALUE"

      disks = [
        {
          type    = "VALUE"
          slot    = "VALUE"
          size    = "VALUE"
          ssd     = false
          storage = "VALUE"
          backup  = false
          cache   = "VALUE"
          asyncio = "VALUE"
          format  = "VALUE"
        }
      ]
    },
  ]
}
