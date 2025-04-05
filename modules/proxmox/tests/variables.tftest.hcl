variables {
  disk_template = {
    type    = "scsi"
    slot    = "scsi0"
    size    = "8G"
    ssd     = true
    storage = "SSD"
    backup  = false
    cache   = "none"
    asyncio = "io_uring"
    format  = "raw"
  }

  vm_template = {
    role      = "control"
    memory    = 8192
    cpu       = 8
    ipconfig  = "ip=192.168.0.150/24,gw=192.168.0.1"
    template  = "ALPINE-k8s-worker-nodes-template"
    desc      = "K8S node which contains control node components"
    tags      = [ "k8s" ]
    disks     = [ ]
  }

  pool_name   = "example-k8s-cluster-name"
  vms_prefix  = "k8s"

  vms_sshkeys = "~/.ssh/id_ed25519.pub"

  #vms_cn_template = "ALPINE-k8s-master-nodes-template"
  vms_ci_storage  = "SSD"

  vms = [ ]
}

mock_provider "proxmox" {
  
}

run "vms_sshkeys_failed" {
  command = plan

  variables {
    vms_sshkeys = "unexist-path.pub"
  }

  expect_failures = [var.vms_sshkeys]
}

run "vms_ide_disks_failed" {
  command = plan

  variables {
    vms = [
      merge(var.vm_template, { disks = [ for ind in range(5): merge(var.disk_template, { type = "ide" }) ] })
    ]
  }

  expect_failures = [ var.vms[0].disks ]
}

run "vms_scsi_disks_failed" {
  command = plan

  variables {
    vms = [
      merge(var.vm_template, { disks = [ for ind in range(32): merge(var.disk_template, { type = "scsi" }) ] })
    ]
  } 
  
  expect_failures = [ var.vms[0].disks ] 
}

run "vms_sata_disks_failed" {
  command = plan

  variables {
    vms = [
      merge(var.vm_template, { disks = [ for ind in range(6): merge(var.disk_template, { type = "sata" }) ] })
    ]
  }

  expect_failures = [ var.vms[0].disks ]
}

run "vms_virtio_disks_failed" {
  command = plan
  
  variables {
    vms = [
      merge(var.vm_template, { disks = [ for ind in range(17): merge(var.disk_template, { type = "virtio" }) ] })
    ]
  }

  expect_failures = [ var.vms[0].disks ]
}
