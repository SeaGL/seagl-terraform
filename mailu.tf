resource "openstack_networking_secgroup_v2" "mailu" {
  name = "mailu"
}

resource "openstack_networking_secgroup_rule_v2" "mailu-ipv4-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.mailu.id
}

resource "openstack_networking_secgroup_rule_v2" "mailu-ipv6-egress" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.mailu.id
}

resource "openstack_networking_secgroup_rule_v2" "mailu-icmp4-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.mailu.id
}

resource "openstack_networking_secgroup_rule_v2" "mailu-tcp4-ingress" {
  for_each          = toset(["22", "25", "80", "110", "143", "443", "465", "587", "993", "995"])
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value
  port_range_max    = each.value
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.mailu.id
}

resource "openstack_compute_instance_v2" "mailu" {
  name        = "mailu"
  flavor_name = "m1.medium"
  key_pair    = "AJ OpenStack bootstrap" # TODO lol
  security_groups = [
    openstack_networking_secgroup_v2.mailu.name
  ]

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "5e7b09b5-03f1-4f01-bc1b-41db2e1b09d1" # Ubuntu 22.04
    volume_size           = 30
    delete_on_termination = true
  }

  network {
    name = "general_servers2"
  }
}
