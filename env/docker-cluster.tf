# TODO do the equivalent of cloud-init ssh_pwauth: false

data "ignition_user" "gh-actions" {
  name  = "gh-actions"
  gecos = "Privileged User"
  # Looking for sudo cloud-init config equivalent? See below.
  shell = "/bin/bash"
  # No lock_passwd=true option in the Ignition provider, so we just let Ansible take care of it
  no_user_group = true
  uid           = 1027
  ssh_authorized_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwA5jA6XgkCiaEGzFzp6EiEIzy73UQuQ3fYZLf8HA/l"
  ]
}

data "ignition_file" "gh-actions-sudoers" {
  path = "/etc/sudoers.d/90-gh-actions"
  content {
    content = "gh-actions ALL=(ALL) NOPASSWD:ALL"
  }
}

# XXX this is probably better provided as a sysext, but those aren't fully baked upstream yet
# So: https://docs.fedoraproject.org/en-US/fedora-coreos/os-extensions/
# N.B. don't be surprised if it takes like, 4 boots for this to settle properly
data "ignition_systemd_unit" "install-python-unit" {
  name    = "rpm-ostree-install-python3.service"
  enabled = true
  content = <<EOT
      [Unit]
      Description=Install Python on first boot
      Wants=network-online.target
      After=network-online.target
      Before=zincati.service
      ConditionPathExists=!/var/lib/%N.stamp

      [Service]
      Type=oneshot
      RemainAfterExit=yes
      ExecStart=/usr/bin/rpm-ostree install -y --allow-inactive python3
      ExecStart=/usr/bin/touch /var/lib/%N.stamp
      ExecStart=/usr/bin/systemctl --no-block reboot

      [Install]
      WantedBy=multi-user.target
    EOT
}

data "ignition_config" "coreos-bootstrap" {
  users = [
    data.ignition_user.gh-actions.rendered,
  ]
  files = [
    data.ignition_file.gh-actions-sudoers.rendered,
  ]
  systemd = [
    data.ignition_systemd_unit.install-python-unit.rendered,
  ]
}

module "docker-cluster-vm" {
  source        = "../simple_vm"
  name          = "docker-cluster"
  ports         = [22, 443, 2375]  # TODO lock down this control port to the OSUOSL network
  port_ranges   = [[23000, 23050]] # https://github.com/nextcloud/docker-socket-proxy#example-when-operated-on-a-different-host
  instance_type = "m1.large"
  network       = "general_servers2"
  image_uuid    = "0cbd4881-026e-4b2f-8883-2aca75af2ca1" # CoreOS 40
  disk_size     = 20
  dns_zone      = aws_route53_zone.apex
  user_data     = data.ignition_config.coreos-bootstrap.rendered
}
