resource "proxmox_vm_qemu" "vms" {
  count = length(var.vms)

  name  = "${var.vms_prefix}-${var.vms[count.index].role}-node-${count.index + 1}"
  desc  = var.vms[count.index].desc
  agent = 0
  tags  = join(",", concat([ var.vms[count.index].role ], var.vms[count.index].tags))

  pool        = var.pool_name
  target_node = "pve"

  clone      = var.vms[count.index].template
  boot       = "order=scsi0;net0"
  full_clone = true
  protection = true

  os_type = "cloud-init"
  sockets = 1
  cores   = var.vms[count.index].cpu
  memory  = 8192
  hotplug = "network,disk,usb,cpu"
  scsihw  = "virtio-scsi-pci"

  ipconfig0  = var.vms[count.index].ipconfig
  sshkeys    = file(var.vms_sshkeys)

  network {
    id       = 0
    bridge   = "vmbr0"
    firewall = true
    mtu      = 1
    model    = "virtio"
    queues   = 8
  }

  disk {
    type    = "cloudinit"
    storage = var.vms_ci_storage
    slot    = "ide0"
  }

  dynamic "disk" {
    for_each = var.vms[count.index].disks

    content {
      type       = "disk"
      size       = disk.value.size
      storage    = disk.value.storage
      emulatessd = disk.value.ssd
      backup     = disk.value.backup
      cache      = disk.value.cache
      asyncio    = disk.value.asyncio
      format     = disk.value.format
      slot       = disk.value.slot
    }
  }
}
