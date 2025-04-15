variables {
  node_template = {
    ssh_user  = "VALUE"
    ssh_port  = 1
    ssh_host  = "192.168.0.105"
    role      = "control"
  }

  k8s_nodes     = [ ]

  ssh_private_key_file = "~/.ssh/id_ed25519"
}

run "node_role_failed" {
  command = plan

  variables {
    k8s_nodes = [
      merge(var.node_template, { role = "unsupported_role" })
    ]
  }

  expect_failures = [ var.k8s_nodes ]
}

run "node_ssh_port_failed_less" {
  command = plan

  variables {
    k8s_nodes = [
      merge(var.node_template, { ssh_port = 0 })
    ]
  }

  expect_failures = [ var.k8s_nodes[0].ssh_port ]
}

run "node_ssh_port_failed_greater" {
  command = plan

  variables {
    k8s_nodes = [
      merge(var.node_template, { ssh_port = 65536 })
    ]
  }

  expect_failures = [ var.k8s_nodes ]
}

run "ssh_private_key_file_failed" {
  command = plan

  variables {
    ssh_private_key_file = "unexist.key"
  }

  expect_failures = [ var.ssh_private_key_file ]
}
