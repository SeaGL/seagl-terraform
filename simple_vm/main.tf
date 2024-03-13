resource "openstack_networking_secgroup_v2" "main-sg" {
  name = var.name
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
}
