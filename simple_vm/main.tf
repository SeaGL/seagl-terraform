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
  # Looking for a key_pair?
  # We set the bootstrap key in cloud-init below to one in GitHub Actions.
  # Don't add a key_pair here; it's a no-op with the cloud-init config, and makes everything *really* confusing.
  security_groups = [
    openstack_networking_secgroup_v2.main-sg.name
  ]

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = var.image_uuid
    volume_size           = var.disk_size
    delete_on_termination = true
  }

  network {
    name = var.network
  }

  lifecycle {
    ignore_changes = [user_data, block_device["uuid"], key_pair]
  }

  user_data = <<-EOT
    #cloud-config
    ssh_pwauth: false
    users:
    # As in seagl-ansible/roles/users/tasks/main.yml
    - name: "gh-actions"
      gecos: "Privileged User"
      sudo: "ALL=(ALL) NOPASSWD:ALL"
      shell: "/bin/bash"
      lock_passwd: true
      create_groups: false
      uid: 1027
      ssh_authorized_keys:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwA5jA6XgkCiaEGzFzp6EiEIzy73UQuQ3fYZLf8HA/l"
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
