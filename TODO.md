# TODO

## Main tasks
- [ ] Prepare VMs on follow environments
  - [X] Proxmox VE
  - [ ] Yandex Cloud
- [X] Deploy K8S cluster of modes
  - [X] Standalone
  - [ ] High availability
- [ ] Deploy WireGuard gateway

## Addition tasks
- [ ] Refine the terraform-proxmox-provider and configurations for correct operration with:
  - [ ] pools
  - [ ] users
- [ ] GPG-based verification of terraform binaries in devcontainer

# test coverage

## modules/proxmox
- [X] Validation of variables
- [ ] Validation of created VMs
