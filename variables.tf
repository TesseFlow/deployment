variable "vault_secret_path" {
  type        = string
  description = "Vault secret storage path"
  nullable    = false
}

variable "vault_secret_kv_path" {
  type        = string
  description = "Vault data path in KV store"
  nullable    = false
}

variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API url"
  nullable    = false
}