variable "pool_name" {
  type        = string
  description = "VM pool name on Proxmox"
}

variable "vms_prefix" {
  type        = string
  description = "VM names prefix"
  default     = "k8s"
}

variable "vms_sshkeys" {
  type        = string
  description = "Path to SSH public key file"
  nullable    = false

  validation {
    condition     = fileexists(var.vms_sshkeys)
    error_message = "SSH public key file unexist: ${var.vms_sshkeys}"
  }
}

variable "vms_ci_storage" {
  type        = string
  description = "CloudInit disk storage name"
  nullable    = false
}

variable "vms" {
  type = list(object({
    cpu       = number
    memory    = number
    role      = string
    ipconfig  = string
    template  = string
    desc      = string
    tags      = list(string)

    disks = list(object({
      type    = string
      size    = string
      storage = string
      ssd     = bool
      backup  = bool
      cache   = string
      asyncio = string
      format  = string
      slot    = string
    }))
  }))

  description = "Disks information of control node VMs. See detailed schema description in README.md"
  nullable    = false

  validation {
    condition     = alltrue([for disk in flatten(var.vms[*].disks) : disk.type == "scsi" || disk.type == "ide" || disk.type == "sata" || disk.type == "virtio"])
    error_message = "Type of disks must be one of 'scsi', 'ide' or 'sata', 'virtio'"
  }

  validation {
    condition     = length([for disk in flatten(var.vms[*].disks) : true if disk.type == "scsi"]) <= 31
    error_message = "SCSI disks count must be less or equal to 31 for concrete VM"
  }

  validation {
    condition     = length([for disk in flatten(var.vms[*].disks) : true if disk.type == "ide"]) <= 4
    error_message = "IDE disks count must be less or equal to 4 for concrete VM"
  }

  validation {
    condition     = length([for disk in flatten(var.vms[*].disks) : true if disk.type == "sata"]) <= 5
    error_message = "SATA disks count must be less or equal to 6 for concrete VM"
  }

  validation {
    condition     = length([for disk in flatten(var.vms[*].disks): true if disk.type == "virtio"]) <= 16
    error_message = "VIRTIO disks count must be less or equal to 16 for concrete VM"
  }
}
