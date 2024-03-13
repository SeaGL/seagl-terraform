resource "openstack_networking_secgroup_v2" "nc-office" {
  name                 = "nc-office"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "nc-office-ipv4-egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nc-office.id
}

resource "openstack_networking_secgroup_rule_v2" "nc-office-ipv6-egress" {
  direction         = "egress"
  ethertype         = "IPv6"
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.nc-office.id
}

resource "openstack_networking_secgroup_rule_v2" "nc-office-icmp4-ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nc-office.id
}

resource "openstack_networking_secgroup_rule_v2" "nc-office-tcp4-ingress" {
  for_each          = toset(["22", "80", "443"])
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value
  port_range_max    = each.value
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nc-office.id
}

resource "openstack_compute_instance_v2" "nc-office" {
  name        = "nc-office"
  flavor_name = "m1.small"
  key_pair    = "AJ OpenStack bootstrap" # TODO lol
  security_groups = [
    openstack_networking_secgroup_v2.nc-office.name
  ]

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "5e7b09b5-03f1-4f01-bc1b-41db2e1b09d1" # Ubuntu 22.04
    volume_size           = 15
    delete_on_termination = true
  }

  network {
    name = "general_servers2"
  }
}
