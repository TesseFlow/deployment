locals {
  k8s_nodes_by_role = {
    for node in var.k8s_nodes: upper(node.role) => node...
  }

  k8s_workers = lookup(local.k8s_nodes_by_role, "WORKER", [ ])
  k8s_controls = lookup(local.k8s_nodes_by_role, "CONTROL", [ ])
}

resource "ansible_group" "workers" {
  name = "k8s_workers"

  variables = {

  }
}

resource "ansible_group" "controls" {
  name = "k8s_controls"

  variables = {

  }
}

resource "ansible_group" "k8s" {
  name      = "k8s_nodes"
  children  = [ "k8s_workers", "k8s_controls" ]

  variables = {

  }

  depends_on = [ ansible_group.workers, ansible_group.controls ]
}

resource "ansible_host" "worker_nodes" {
  count = length(local.k8s_workers)

  name    = "worker-node-${count.index}"
  groups  = [ "k8s_workers" ]

  variables = {
    ansible_host = local.k8s_workers[count.index].ssh_host
    ansible_port = local.k8s_workers[count.index].ssh_port
    ansible_user = local.k8s_workers[count.index].ssh_user

    ansible_ssh_private_key_file = var.ssh_private_key_file
  }

  depends_on = [ ansible_group.k8s ]
}

resource "ansible_host" "control_nodes" {
  count = length(local.k8s_controls)

  name    = "control-node-${count.index}"
  groups  = [ "k8s_controls" ]

  variables = {
    ansible_host = local.k8s_controls[count.index].ssh_host
    ansible_user = local.k8s_controls[count.index].ssh_user
    ansible_port = local.k8s_controls[count.index].ssh_port

    ansible_ssh_private_key_file = var.ssh_private_key_file
  }

  depends_on = [ ansible_group.k8s ]
}

resource "ansible_playbook" "deploy_controls" {
  count = length(local.k8s_controls)

  name        = "control-node-${count.index}"
  playbook    = "playbooks/controls.yml"
  replayable  = true

  extra_vars = {

  }

  depends_on = [ ansible_host.control_nodes ]
}

resource "ansible_playbook" "deploy_workers" {
  count = length(local.k8s_workers)

  name        = "worker-node-${count.index}"
  playbook    = "playbooks/workers.yml"
  replayable  = true

  extra_vars = {

  }

  depends_on = [ ansible_host.worker_nodes, ansible_playbook.deploy_controls ]
}
