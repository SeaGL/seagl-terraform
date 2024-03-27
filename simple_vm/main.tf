resource "openstack_networking_secgroup_v2" "main-sg" {
  name                 = var.name
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ipv4-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.main-sg.id
}

resource "openstack_networking_secgroup_rule_v2" "ipv6-egress" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.main-sg.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp4-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.main-sg.id
}

resource "openstack_networking_secgroup_rule_v2" "tcp4-ingress" {
  for_each          = toset([for k in var.ports : tostring(k)])
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value
  port_range_max    = each.value
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.main-sg.id
}

resource "openstack_compute_instance_v2" "instance" {
  name        = var.name
  flavor_name = var.instance_type
  key_pair    = "AJ OpenStack bootstrap" # TODO lol
  security_groups = [
    openstack_networking_secgroup_v2.main-sg.name
  ]

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "5e7b09b5-03f1-4f01-bc1b-41db2e1b09d1" # Ubuntu 22.04
    volume_size           = var.disk_size
    delete_on_termination = true
  }

  network {
    name = var.network
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  user_data = <<-EOT
    #cloud-config
    ssh_pwauth: false
    users:
    - name: "gh-actions"
      gecos: "Privileged User"
      sudo: "ALL=(ALL) NOPASSWD:ALL"
      shell: "/bin/bash"
      lock_passwd: true
      create_groups: false
      uid: 1027
      ssh_authorized_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRCJCQ1UD9QslWDSw5Pwsvba0Wsf1pO4how5BtNaZn0xLZpTq2nqFEJshUkd/zCWF7DWyhmNphQ8c+U+wcmdNVcg2pI1kPxq0VZzBfZ7cDwhjgeLsIvTXvU+HVRtsXh4c5FlUXpRjf/x+a3vqFRvNsRd1DE+5ZqQHbOVbnsStk3PZppaByMg+AZZMx56OUk2pZCgvpCwj6LIixqwuxNKPxmJf45RyOsPUXwCwkq9UD4me5jksTPPkt3oeUWw1ZSSF8F/141moWsGxSnd5NxCbPUWGoRfYcHc865E70nN4WrZkM7RFI/s5mvQtuj8dRL67JUEwvdvEDO0EBz21FV/iOracXd2omlTUSK+wYrWGtiwQwEgr4r5bimxDKy9L8UlaJZ+ONhLTP8ecTHYkaU1C75sLX9ZYd5YtqjiNGsNF+wdW6WrXrQiWeyrGK7ZwbA7lagSxIa7yeqnKDjdkcJvQXCYGLM9AMBKWeJaOpwqZ+dOunMDLd5VZrDCU2lpCSJ1M="
  EOT
}

resource "aws_route53_record" "dns-a" {
  zone_id = var.dns_zone.zone_id
  name    = "${var.name}.host.${var.dns_zone.name}"
  type    = "A"
  ttl     = "300"
  records = [
    openstack_compute_instance_v2.instance.access_ip_v4
  ]
}
