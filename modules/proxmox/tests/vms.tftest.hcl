variables {
  vms = [
    {
      role      = "control"
      memory    = 1024
      cpu       = 4
      ipconfig  = "ip=192.168.0.150/24,gw=192.168.0.1" 
      template  = "test-template"
      tags      = ["test-1", "test-2"]
      desc      = "test-desc"

      disks = [
        {
          type    = "scsi"
          slot    = "scsi0"
          size    = "8G"
          ssd     = true
          storage = "SSD"
          backup  = false
          cache   = "none"
          asyncio = "io_uring"
          format  = "raw"
        },
        {
          type    = "scsi"
          slot    = "scsi1"
          size    = "100G"
          ssd     = false
          storage = "HDD"
          backup  = false
          cache   = "none"
          asyncio = "io_uring"
          format  = "raw"
       },
      ]
    },
  ]

  pool_name       = "test-pool"
  vms_sshkeys     = "~/.ssh/id_ed25519.pub"
  vms_ci_storage  = "exmp-storage"
  vms_prefix      = "test"
}

mock_provider "proxmox" {

}

run "vms_common" {
  command = plan

  assert {
    condition     = length(proxmox_vm_qemu.vms) == 1
    error_message = "unexpected length of k8s nodes resource"
  }

  assert {
    condition     = alltrue([ for left, right in zipmap(proxmox_vm_qemu.vms[*].name, [ "test-control-node-1" ]): left == right ])
    error_message = "unexpected name of vms"
  }

  assert {
    condition     = alltrue([ for left, right in zipmap(proxmox_vm_qemu.vms[*].pool, [ "test-pool" ]): left == right ])
    error_message = "unexpected pool name of vms"
  }

  assert {
    condition     = alltrue([ for left, right in zipmap(proxmox_vm_qemu.vms[*].clone, [ "test-template" ]): left == right ])
    error_message = "unexpected base clone name of vms"
  }
}

run "vms_network" {
  command = plan

  assert {
    condition     = alltrue([ for vm in proxmox_vm_qemu.vms: length(vm.network) == 1])
    error_message = "only one network block accepted"
  }
}

run "vms_disks" {
  command = plan
 
  assert {
    condition     = alltrue([ for vm in proxmox_vm_qemu.vms: length(vm.disk) == 3 ])
    error_message = "unoccrect count of disk blocks"
  } 

  assert {
    condition     = alltrue([ for vm in proxmox_vm_qemu.vms: vm.disk[0].type == "cloudinit" && vm.disk[0].slot == "ide0" ])
    error_message = "first disk of vm must be cloud init and in slot ide0"
  }
}