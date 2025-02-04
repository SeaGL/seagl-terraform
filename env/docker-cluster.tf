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

data "ignition_config" "coreos-bootstrap" {
  users = [
    data.ignition_user.gh-actions.rendered,
  ]
  files = [
    data.ignition_file.gh-actions-sudoers.rendered,
  ]
}

module "docker-cluster-vm" {
  source        = "../simple_vm"
  name          = "docker-cluster"
  ports         = [22]
  instance_type = "m1.large"
  network       = "general_servers2"
  image_uuid    = "0cbd4881-026e-4b2f-8883-2aca75af2ca1" # CoreOS 40
  disk_size     = 20
  dns_zone      = aws_route53_zone.apex
  user_data     = data.ignition_config.coreos-bootstrap.rendered
}
