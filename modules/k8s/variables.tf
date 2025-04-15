variable "k8s_nodes" {
  type = list(object({
    role      = string
    ssh_host  = string
    ssh_user  = string
    ssh_port  = number
  }))
  nullable    = false
  description = "A k8s worker role nodes description. See schema description in README.md"

  validation {
    condition     = alltrue([ for node in var.k8s_nodes: upper(node.role) == "CONTROL" || upper(node.role) == "WORKER" ])
    error_message = "node role must be one of 'control' or 'worker'"
  }

  validation {
    condition     = alltrue([ for node in var.k8s_nodes: node.ssh_port > 0 && node.ssh_port < 65536 ])
    error_message = "node port must be between 0(exclusive) and 65536(exclusive)"
  }
}

variable "ssh_private_key_file" {
  type        = string
  nullable    = false
  description = "Path to valid SSH private key file"

  validation {
    condition     = fileexists(var.ssh_private_key_file)
    error_message = "file ${var.ssh_private_key_file} unexist or user does't have permissions to read it"
  }
}
